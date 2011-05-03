### USAGE ###
# MODEL=User FILE="db/seed/development/user.csv" rake export_model
 
task :export_model => :environment do
  require 'csv'

  MODEL = ENV["MODEL"].constantize
  FILE = ENV["FILE"]
  objects = MODEL.find(:all)
 
  CSV.open(File.join(Rails.root, FILE), "w") do |csv|
    csv << MODEL.column_names
    objects.each do |object|
      csv << MODEL.column_names.map {|c| object.send(c)}
    end
  end
end