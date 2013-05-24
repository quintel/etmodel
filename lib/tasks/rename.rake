require 'csv'

desc "Rename InputElement#key using CSV file specified by path=path/to/file."
task :rename => [:environment] do

  file_path = ENV['path']
  force   = ENV['force']

  unless file_path
    raise ArgumentError.new("ArgumentError: You should specify which `path`")
  end

  raise "#{ file_path } does not exist" unless File.exists?(file_path)

  if force
    puts "For real buddy..."
  else
    puts "Dry run... append force=true for the real thing."
  end

  CSV.foreach(file_path) do |line|

  old_value = line.first
  new_value = line.last

  ie = InputElement.find_by_key(old_value)

  if ie
    ie.key = new_value
    ie.save! if force
    puts "SUCCESS: Renamed InputElement from `#{ old_value }` to `#{ new_value }`"
  else
    puts "WARNING: No InputElement found with name `#{ old_value }`!"
  end

  end

  puts "Done!"

end