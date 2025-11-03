namespace :maintenance do
  desc "Clean up old ActiveRecord sessions"
  task :cleanup_sessions => :environment do
    ActiveRecord::SessionStore::Session.delete_all( ['updated_at < ?', 3.days.ago] )
  end


  desc "cleanup output element series table"
  task :cleanup_output_element_series => :environment do
    OutputElementSerie.find_each do |s|
      chart_id = s.output_element_id
      if chart_id.blank? || !OutputElement.exists?(chart_id)
        puts "Removing broken output element reference"
        s.destroy
        next
      end
    end
  end

  desc "check referential integrity"
  task :check_ref => :environment do
    puts "Use FORCE=1 parameter to actually delete stuff"
    @deleted = 0

    puts "* Output Element Series"
    OutputElementSerie.find_each do |a|
      unless a.output_element
        puts "! Missing output_element, id=#{a.id}"
        if ENV["FORCE"]
          a.destroy
          @deleted += 1
        end
      end
    end

    puts "Deleted #{@deleted} elements"
  end
end
