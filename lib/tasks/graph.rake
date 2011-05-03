namespace :graph do
  desc 'Backup Graphs to import/bkp-TIME.sql'
  task "backup" do
    puts "/usr/local/mysql/bin/mysqldump -u root quintel_em_dev > import/bkp-#{Time.now.to_i}.sql"
    system "/usr/local/mysql/bin/mysqldump -u root quintel_em_dev > import/bkp-#{Time.now.to_i}.sql"
  end

  desc "Import Graph"
  task 'import' => :environment do
    # TODO sebi - I just copied this from GraphsController. Should move into own class
    if ENV['version'].blank? or ENV['file'].blank?
      puts <<-EOS
version or zip_file not defined.
Use like:
rake graph:import version=501 file=import.zip
EOS
      raise
    end
    require 'zip/zip'
    version = ENV['version']
    file = ENV['file']
    version_path = "import/#{version}"

    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(version_path, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end

    countries = Dir.entries(version_path).select{|country_dir| 
      # check that file is directory. excluding: "." and ".."
      File.directory?("#{version_path}/#{country_dir}") and !country_dir.match(/^\./)
    }

    csv_import = CsvImport.new(version, countries.first)
    blueprint = csv_import.create_blueprint
    blueprint.update_attribute :description, 'imported from command line'

    countries.each do |country|
      csv_import = CsvImport.new(version, country)
      dataset = csv_import.create_dataset(blueprint.id, country)
      Graph.create :blueprint_id => blueprint.id, :dataset_id => dataset.id
    end
  end
end

