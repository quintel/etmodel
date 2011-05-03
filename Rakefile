require File.expand_path('../config/application', __FILE__)
require 'rake'

Etm::Application.load_tasks

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'app/**/*.rb']   # optional
end

desc "Runs annotate on all models, incl. app/pkg"
task :annotate do
  Dir.glob("app/pkg/").each do |dir|
    puts "* Annotating: #{dir}"
    system "annotate --model-dir #{dir}"
  end
  puts "* Annotating: app/models"
  system "annotate"
end
