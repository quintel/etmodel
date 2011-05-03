namespace :blackbox do
  task :get_files => :environment do

    av = ActionView::Base.new(Rails::Application::Configuration.new(Rails.root).view_path)
    
    av.class_eval do
      include ApplicationHelper
    end
    
    # av.instance_eval do
      @blackbox               = Blackbox.last
      @blackbox_scenarios     = BlackboxScenario.all
      @blackbox_output_series = @blackbox.blackbox_output_serie.includes(:output_element_serie)
      @blackbox_gqueries      = @blackbox.blackbox_gqueries.includes(:gquery)
    # end
    
    # av.render(:partial => "admin/blackboxes/raw_rspec", :layout => nil)
    av.render(:partial => "admin/blackboxes/raw_rspec", :locals => {
      :blackbox               => @blackbox,
      :blackbox_scenarios     => @blackbox_scenarios,
      :blackbox_output_series => @blackbox_output_series,
      :blackbox_gqueries      => @blackbox_gqueries      
    },
    :layout => nil)

  end
end