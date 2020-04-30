# frozen_string_literal: true

# rubocop:disable  Metrics/BlockLength, Style/SymbolArray, MultilineBlockChain
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

      attributes.except!('created_at', 'updated_at')
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
      # Some relations are optional
      new_foreign_val = related.present? ? related[new_index] : nil
      # add new key
      record[new_foreign_key] = new_foreign_val

      # remove old key
      record.delete old_foreign_key
      record
    end.reject(&:blank?)

    puts "#{migrated_records.select(&:present?).count} of "\
         "#{migrated_records.count} could be migrated."

    File.write(refering_yaml, migrated_records.to_yaml)
  end

  # This task was used for splitting input_Elements and slides into seperate
  # files. Remember to delete the starting yaml after to make sure you don't
  # get duplicate index errors.
  #
  # I write the command like this in  zsh:
  # $ rake "ymodel:split_yaml[config/interface/input_elements.yml,slide_key]"
  task :split_yaml, [:yaml_file, :group_by_key] => [:environment] do |_t, args|
    YAML.load_file(args.yaml_file).group_by do |record|
      record[args.group_by_key]
    end.each do |filename, records|
      file = File.join(Rails.root,
                       File.dirname(args.yaml_file),
                       "#{filename.downcase}.yml")
      File.write(file, records.to_yaml)
    end
  end

  # This task is quite the mess. My guess that we wont need it often if at all.
  # Just keeping it here in case its handy to have in the future.
  # I write the command like this in  zsh:
  # $ rake "ymodel:sort_yaml[InputElement]"
  desc 'Sort yaml files alphabetically but keep key name on top.'
  task :sort_yaml, [:model] => [:environment] do |_t, args|
    Kernel.const_get(args.model.camelcase).source_files.each do |file_path|
      current_block = []
      blocks = []

      starts_with_dash =
        lambda do |text|
          text.match?(/^-{1} /)
        end

      strip_yaml_grammar =
        lambda do |line|
          line.sub(/^-{1} /, '')
            .sub(/^ {2}/, '')
        end

      File.readlines(file_path).each do |line|
        # empty current_block if we open up a new object.
        if starts_with_dash.call(line)
          blocks << current_block
          current_block = []
        end
        current_block << strip_yaml_grammar.call(line)
      end

      blocks << current_block

      # sort blocks
      blocks = blocks.each_with_index.flat_map do |lines, index1|
        next lines if index1.zero?

        # Make sure the key is on the first line of the yaml object. sort the
        # alphabetically.
        lines =
          lines.sort do |a, b|
            next -1 if a =~ /^key/

            next 1 if b =~ /^key/

            a <=> b
          end

        # Reduce the arrays to a single yaml string
        lines.each_with_index.map do |line, index2|
          # Inject YAML grammar
          index2.zero? ? "- #{line}" : "  #{line}"
        end
      end.reduce(&:+)
      File.write(file_path, blocks)
    end
  end

  # I write the command like this in  zsh:
  # $ rake "ymodel:remove_empty_values[InputElement]"
  desc 'Remove empty values from all yaml files that belong to a model.'
  task :remove_empty_values, [:model] => [:environment] do |_t, args|
    Kernel.const_get(args.model.camelcase).source_files.each do |file_path|
      data = YAML.load_file(file_path)
      transformed_data =
        data.map do |record|
          record.delete_if { |_k, v| v.blank? }
        end
      File.write(file_path, transformed_data.to_yaml)
    end
  end

  # I write the command like this in  zsh:
  # $ rake "ymodel:remove_ids[InputElement]"
  desc 'Remove ids from all yaml files that belong to a model.'
  task :remove_ids, [:model] => [:environment] do |_t, args|
    Kernel.const_get(args.model.camelcase).source_files.each do |file_path|
      data = YAML.load_file(file_path)
      transformed_data =
        data.map do |record|
          record.delete_if { |k, _v| k == 'id' }
        end
      File.write(file_path, transformed_data.to_yaml)
    end
  end
end
# rubocop:enable  Metrics/BlockLength, Style/SymbolArray, MultilineBlockChain
