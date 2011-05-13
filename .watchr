# This usually sits at the root of the project and is called ".watchr"
@spec_cmd = "bundle exec rspec"
@cuc_cmd  = "bundle exec cucumber"

# Convenience methods ########################################################
# Working on eventually adding Growl support. The problem right now is catching
# the output of a command, while at the same time piping it out to the stdout.
# Right now I don't know how to do it without stripping the ANSI color tags.
# def growl(message)
#  if message.match /(\d+)\s(errors?|failures?)/ # Rspec failures
#    Growl.notify "#{$1} spec #{$2}", :title => 'Watchr: specs failing'
#  elsif message.match /(\d+)\sfailed/ # Cucumber failures
#    Growl.notify "#{$1} features failed", :title => 'Watchr: features failing'
#  end
# end

def run(command)
  puts "\n\n"
  puts command
  system command
  puts "\n\n"
  @interrupted = false
end

def run_all_specs
  result = run "#{@spec_cmd} spec/"
end

def run_spec(spec)
  result = run "#{@spec_cmd} #{spec}"
end

def related_specs(path)
  Dir['spec/**/*.rb'].select do |file|
    file =~ /#{File.basename(path).split('.').first}_spec.rb/
  end
end

def run_all_features
  result = run @cuc_cmd
end

def run_feature(feature)
  result = run "#{@cuc_cmd} #{feature}"
end

def run_suite
  run_all_specs
  # run_all_features
end

# Watchr rules ###############################################################
watch('spec/spec_helper\.rb') { run_all_specs }
watch('spec/support/.*') { run_all_specs }
watch('spec/.*_spec\.rb') { |m| run_spec m[0] }
watch('app/.*\.rb') { |m| related_specs(m[0]).map { |s| run_spec s } }
watch('lib/.*\.rb') { |m| related_specs(m[0]).map { |s| run_spec s } }
watch('features/support/.*') { |m| run_all_features }
watch('features/.*\.feature') { |m| run_feature m[0] }

# Signals ####################################################################
@interrupted = false

Signal.trap 'QUIT' do # CTRL-\
  puts " --- Running all specs ---\n\n"
  run_all_specs
end

Signal.trap 'INT' do # CTRL-C
  if @interrupted
    abort "\n"
  else
    puts 'Interrupt a second time to quit'
    puts " --- Running entire test suite ---\n\n"
    @interrupted = true
    sleep 1.5
    run_suite
  end
end