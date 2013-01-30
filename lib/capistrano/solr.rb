namespace :solr do
  desc "Reindex everything"
  task :reindex, :roles => [:app] do
    rake_on_current 'sunspot:reindex'
  end
end
