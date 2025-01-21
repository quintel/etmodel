require 'bundler'

# Helper to search for gem usage in the application
def grep_usage(gem_name)
  puts "Searching for usage of '#{gem_name}' in the application..."
  result = `grep -r '#{gem_name}' app config lib`
  if result.strip.empty?
    puts "No usage found for '#{gem_name}'."
  else
    puts "Usage found for '#{gem_name}':\n#{result}"
  end
rescue => e
  puts "Error running grep for '#{gem_name}': #{e.message}"
end

puts "Checking which gems are loaded successfully...\n\n"

Bundler.load.specs.each do |spec|
  begin
    require spec.name
    puts "#{spec.name}: Loaded successfully"
  rescue LoadError
    puts "#{spec.name}: Could not load (potentially unused)"
    grep_usage(spec.name)
  rescue NameError => e
    puts "#{spec.name}: Could not initialize properly (#{e.message})"
    grep_usage(spec.name)
  end
end

puts "\nCheck complete. Review the output above to identify unused gems."
