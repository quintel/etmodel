namespace :maintenance do
  desc "cleanup output element series table"
  task :cleanup_output_element_series => :environment do
    OutputElementSerie.find_each do |s|
      chart_id = s.output_element_id
      if chart_id.blank? || !OutputElement.exists?(chart_id)
        puts "Removing broken output element reference"
        s.destroy
        next
      end

      # Now let's create a unique, possibly meaningful name
      label       = s.label.downcase.gsub(/[^a-z0-9_]/, '_')
      gquery_name = "chart_#{s.label}_#{s.group}_#{s.output_element.key}_#{s.id}"
      final_name  = gquery_name.downcase.gsub(/[^a-z0-9_]/, '_').gsub(/_{1,}/, '_')
      puts final_name

      s.update_attribute :gquery, final_name
      # Be sure you've created a gquery with the same name on the ETE
    end
  end
end