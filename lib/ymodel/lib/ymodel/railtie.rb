require "ymodel/dump"
module YModel
  HOME_DIR = File.dirname(__FILE__)

  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(YModel::HOME_DIR, '../../tasks/y_model.rake')
    end
  end
end
