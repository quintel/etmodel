# frozen_string_literal: true

namespace :ymodel do
  desc 'dump interface models of the provided class to yaml'

  task :dump_interface_model, [:model] => [:environment] do |_t, args|
    include LocalizeDescriptions

    unless args.model
      raise ArgumentError.new("No ['model'] specified")
    end

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
end
