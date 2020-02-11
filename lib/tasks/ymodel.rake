namespace :ymodel do
  desc 'dump interface models of the provided class to yaml'

  task :dump_interface_model, [:model] => [:environment] do |t, args|
    YModel::Dump.(args.model) do |attributes, record|
      dep = AreaDependency.find_by(dependable_type: record.class.name,
                                               dependable_id:   record.id)
      attributes['dependent_on'] = dep&.dependent_on
      attributes
    end
  end
end
