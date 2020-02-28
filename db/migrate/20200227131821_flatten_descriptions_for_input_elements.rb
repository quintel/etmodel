class FlattenDescriptionsForInputElements < ActiveRecord::Migration[5.2]
  def up
    records =
      YAML.load_file(yaml_path).map do |record|
        desc = Description.find_by(describable_type: model_name,
                                  describable_id: record['id'])
        if desc
          record['description'] = {}
          record['description']['content_en'] = desc&.content_en
          record['description']['content_nl'] = desc&.content_nl
          record['description']['short_content_en'] = desc&.short_content_en
          record['description']['short_content_nl'] = desc&.short_content_nl
        end
        record
      end

    File.write(yaml_path, records.to_yaml)
    Description.where(describable_type: model_name)
      .destroy_all
  end

  def down
    YAML.load_file(yaml_path).each do |record|
      Description.create!(describable_type: model_name,
                          describable_id: record['id'],
                          content_en: record['content_en'],
                          content_nl: record['content_nl'],
                          short_content_en: record['short_content_en'],
                          short_content_nl: record['short_content_nl'])
    end
  end

  def yaml_path
    Rails.root.join('config',
                    'ymodel',
                    "#{model_name.underscore.pluralize}.yml")
  end

  def model_name
    'InputElement'
  end
end
