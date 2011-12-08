require File.expand_path('../config/application', __FILE__)
require 'rake'

Etm::Application.load_tasks

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc "Runs annotate on all models"
task :annotate do
  system "annotate -d"
  system "annotate -p before -e tests,fixtures"
end
