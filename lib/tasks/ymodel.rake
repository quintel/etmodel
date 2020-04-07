# frozen_string_literal: true

# rubocop:disable  Metrics/BlockLength
namespace :ymodel do
  desc 'dump interface models of the provided class to yaml'

  task :dump_interface_model, [:model] => [:environment] do |_t, args|
    include LocalizeDescriptions

    raise ArgumentError, "No ['model'] specified" unless args.model

    en_descriptions = {}
    nl_descriptions = {}

    YModel::Dump.call(args.model) do |attributes, record|
      dep = AreaDependency.find_by(dependable_type: record.class.name,
                                   dependable_id: record.id)
      attributes['dependent_on'] = dep&.dependent_on

      desc = Description.find_by(describable_type: record.class.name,
                                 describable_id: record.id)
      if desc
        en_descriptions[record.key] =
          { 'short_content' => desc&.short_content_en,
            'content' => desc&.content_en }
        nl_descriptions[record.key] =
          { 'short_content' => desc&.short_content_nl,
            'content' => desc&.content_nl }
      end

      attributes
    end

    write_to_locale(args.model, 'en', en_descriptions)
    write_to_locale(args.model, 'nl', nl_descriptions)
  end

  # This task is used to migrate from ids to keys as index.

  task :migrate_refering_ids,
       %i[referenced_model refering_model] => [:environment] do |_t, args|
    referenced_model = Kernel.const_get(args.referenced_model.camelcase)
    refering_model   = Kernel.const_get(args.refering_model.camelcase)

    # find the name of the new index
    new_index = referenced_model.index.to_s

    # find the name of the old and new foreign keys please note that we have to
    # set new_index with 'YModel::Relatable#index_on'
    old_foreign_key = args.referenced_model.foreign_key
    new_foreign_key = "#{args.referenced_model}_#{new_index}"

    # Grab and parse yaml files
    refering_yaml = refering_model.send(:source)
    refering_records = YAML.load_file(refering_yaml)
    referenced_records = YAML.load_file(referenced_model.send(:source))

    migrated_records = refering_records.map do |record|
      # Filter out broken records.
      related =
        referenced_records.find do |ref|
          ref['id'] == record[old_foreign_key]
        end

      next unless related.present?

      # add new key
      record[new_foreign_key] = related[new_index]

      # remove old key
      record.delete old_foreign_key
      record
    end.reject(&:blank?)

    puts "#{migrated_records.select(&:present?).count} of "\
         "#{migrated_records.count} could be migrated."

    File.write(refering_yaml, migrated_records.to_yaml)
  end
end
# rubocop:enable  Metrics/BlockLength
