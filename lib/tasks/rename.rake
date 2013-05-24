desc "Renames model attributes as specified in CSV file"
task :rename => [:environment] do

  model_name = ENV['model'].to_s.classify
  attribute  = ENV['attribute']
  file_name  = ENV['file']
  force      = ENV['force'] && ENV['force'].upcase == 'TRUE'
  revert     = ENV['revert'] && ENV['revert'].upcase == 'TRUE'

  unless defined?(model_name)
    raise "Invalid model: #{ model_name }"
  end

  unless model_name.constantize.new.respond_to?(attribute)
    raise "Invalid attribute: #{ model_name } doesn't have #{ attribute } attribute"
  end

  raise "No such file: #{ file_name }" unless File.exists?(file_name)

  puts "Bulk update has started" if force

  changed = 0
  CSV.foreach(file_name) do |line|
    old_value, new_value = line

    old_value, new_value = new_value, old_value if revert

    if old_value != new_value
      changed += 1
      if force
        instance = model_name.constantize.where(attribute.to_sym => old_value).first
        if instance
          instance.send("#{ attribute }=", new_value)
          instance.save!
          print '.'
        else
          print 'x'
        end
      end
    end
  end

  unless force
    puts "#{ changed } out of #{ CSV.read(file_name).count } listed instances of #{ model_name } will be changed"
  else
    puts "\n\nThe #{ attribute } attribute of #{ changed } instances of #{ model_name } has been updated"
  end

end