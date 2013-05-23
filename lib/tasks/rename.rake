desc "Renames model attributes as specified in CSV file"
task :rename => [:environment] do

  model_name = ENV['model'].to_s.classify
  attribute  = ENV['attribute']
  file_name  = ENV['file']
  force      = ENV['force'] && ENV['force'].upcase == 'TRUE'
  revert    = ENV['revert'] && ENV['reverse'].upcase == 'TRUE'

  unless defined?(model_name)
    raise "Invalid model: #{ model_name }"
  end

  unless model_name.constantize.new.respond_to?(attribute)
    raise "Invalid attribute: #{ model_name } doesn't have #{ attribute } attribute"
  end

  raise "No such file: #{ file_name }" unless File.exists?(file_name)

  changed = 0
  CSV.foreach(file_name) do |line|
    old_value, new_value = line
    changed += 1 unless old_value == new_value
  end

  unless force
    puts "#{ changed } out of #{ CSV.read(file_name).count } listed instances of #{ model_name } will be changed"
    exit
  end
  
  puts "Bulk update has started"
  updated = 0
  CSV.foreach(file_name) do |line|
    old_value, new_value = line
    
    old_value, new_value = new_value, old_value if rever
    
    if old_value != new_value
      instance = model_name.constantize.where(attribute.to_sym => old_value).first
      if instance
        instance.send("#{ attribute }=", new_value)
        instance.save!
        updated += 1
      end
      print '.'
    end
  end
  puts "\n\nThe #{ attribute } attribute of #{ updated } instances of #{ model_name } has been updated"
end