production_path = File.expand_path(File.dirname(__FILE__)) + '/production.rb'
production_conf = File.read(production_path)

# Load the production configuration which will form the basis of the staging
# environment. Staging-specific settings may be placed beneath this line.
instance_eval production_conf, production_path
