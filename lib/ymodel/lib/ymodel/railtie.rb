require "ymodel/dump"
module YModel
  class Railtie < Rails::Railtie
    rake_tasks do
       load 'lib/ymodel/ymodel.rake'
     end
  end
end
