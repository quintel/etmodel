class FlattenDependenciesForSlides < ActiveRecord::Migration[5.2]

  def up
    records = YAML.load_file(yaml_path).map do |record|
      dep = AreaDependency.find_by( dependable_type: model_name,
                                    dependable_id: record['id'] )
      record['dependent_on'] = dep&.dependent_on
      record
    end

    File.write(yaml_path, records.to_yaml)
    AreaDependency.where(dependable_type: model_name)
                  .destroy_all
  end

  def down
    YAML.load_file(yaml_path).each do |record|
      AreaDependency.create!( dependable_type: model_name,
                              dependable_id: record['id'],
                              dependent_on: record['dependent_on'])
    end
  end

  def yaml_path
    Rails.root.join('config',
      'ymodel',
      "#{model_name.underscore.pluralize}.yml")
  end

  def model_name
    'Slide'
  end
end
