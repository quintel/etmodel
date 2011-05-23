class HouseSelectionsController < ApplicationController
  
  
  def tool
    session["house_label_new"] = nil
    session["house_label_existing"] = nil
    render :layout => false
  end
  
  def go_back
    session["house_label_new"] = nil
    session["house_label_existing"] = nil
    render :update do |page|
		  page[:house_selection].replace_html( render "select")
    end
  end

  ##
  #
  def set_house_selection_label
    house_type = params[:id]
    house_lbl = params[:lbl]
    session['calculated_hst_sliders'] ||= {}
    session["house_label_#{house_type}"] = house_lbl
    if labels_ready_to_calculate?
      set_insulation_slider(session["house_label_new"],"new")
      set_insulation_slider(session["house_label_existing"],"existing")
      update_installation_sliders
      @perc_new_houses = (percentage_of_new_houses * 100).round(1)
      @perc_existing_houses = (percentage_of_existing_houses * 100).round(1)

      render :update do |page|
			  page[:house_selection].replace_html( render "house_selections/result")
      end
    else
      render :update do |page|
        if house_type == 'new'
          page.call "show_existing_houses_tab"
        else
          page.call "show_new_houses_tab"
        end
      end
    end
  end
  
  def apply_house_selection_labels
    render :update do |page|
      page.call "close_fancybox"
      session['calculated_hst_sliders'].each_with_index do |slider,i|
        slider_call = "App.inputElementsController.get(%s)" % slider.first.to_i
        logger.info "#{slider_call}.set", "{user_value : #{slider.last} };" 
        page.call "#{slider_call}.set", "{ user_value : #{slider.last}} " 
      end
      page.call "App.doUpdateRequest"
    end
    
  end

private

  def labels_ready_to_calculate?
    (session["house_label_new"] && session["house_label_existing"])
  end
    
  def update_installation_sliders
    initialize_installations_sliders("new") # adds all the installation sliders to the session['calculated_hst_sliders']
    initialize_installations_sliders("existing")
    set_existing_installations # fill session['calculated_hst_sliders_existing'] with existing installation sliders values
    set_new_installations    
    calculate_average_installation_sliders
  end
  
  def calculate_average_installation_sliders
    existing_percent = percentage_of_heat_existing_houses
    new_percent = percentage_of_heat_new_houses
    session["calculated_hst_sliders_existing"].each do |slider|
      if slider.first == "47"
        average_share = set_solar_pv_slider
      else
        existing_share = slider.last * existing_percent
        new_share = session["calculated_hst_sliders_new"][slider.first] * new_percent
        average_share = existing_share + new_share
      end
      session['calculated_hst_sliders'][slider.first.to_s] = average_share
    end
  end
	

  #this method updates the solar pv
  def set_solar_pv_slider
    current_pv = Current.gql.query("present:DIVIDE(V(local_solar_pv_grid_connected_energy_energetic;output_of_electricity),Q(potential_roof_pv_production))")
    existing_pv = (session['calculated_hst_sliders_existing']["47"] ? session['calculated_hst_sliders_existing']["47"] : current_pv) * percentage_of_existing_houses
    new_pv = (session['calculated_hst_sliders_new']["47"] ? session['calculated_hst_sliders_new']["47"] : current_pv) * percentage_of_new_houses
    
    return existing_pv + new_pv
  end  
	
  # this method updates the insulation sliders
	def set_insulation_slider(lbl,house_type)
    if house_type == 'new'
  		case lbl
  		  when 'aaa'
  			  value = 5
  			when 'aa'
  				value = 4
        when 'a'
  				value = 3.5
  			when 'b'
  				value = 3
  			when 'c'
  				value = 2.5
  		end		 
    elsif house_type == 'existing'
  		case lbl
        when 'a'
  				value = 2.8
  			when 'b'
  				value = 2.6
  			when 'c'
  				value = 2.4
  			when 'd'
  				value = 2
  			when 'e'
  				value = 1.5
  		end
    end
		if house_type == "existing"
			slider_id = 336
		else
			slider_id = 337
		end
		session['calculated_hst_sliders'][slider_id.to_s] = value
	end
	
	####### HELPER METHODS #########
	
	def set_existing_installations
    case session["house_label_existing"]
      when "a" 
        session['calculated_hst_sliders_existing']["51"] = 55
        session['calculated_hst_sliders_existing']["339"] = 30
        session['calculated_hst_sliders_existing']["48"] = 15
        session['calculated_hst_sliders_existing']["47"] = 100
      when "b"
        session['calculated_hst_sliders_existing']["51"] = 55
        session['calculated_hst_sliders_existing']["333"] = 30
        session['calculated_hst_sliders_existing']["48"] = 15
      when "c"
        session['calculated_hst_sliders_existing']["333"] = 85
        session['calculated_hst_sliders_existing']["48"] = 15
      when "d"
        session['calculated_hst_sliders_existing']["333"] = 100
      when "e"
        session['calculated_hst_sliders_existing']["333"] = 100
    end
  end
  
  def set_new_installations    
    case session["house_label_new"]
      when "aaa"
        session['calculated_hst_sliders_new']["338"] = 85
        session['calculated_hst_sliders_new']["48"] = 15
        session['calculated_hst_sliders_new']["47"] = 100
      when "aa"
        session['calculated_hst_sliders_new']["338"] = 85
        session['calculated_hst_sliders_new']["48"] = 15
        session['calculated_hst_sliders_new']["47"] = 50
      when "a"
        session['calculated_hst_sliders_new']["338"] = 100
      when "b"
        session['calculated_hst_sliders_new']["333"] = 100
      when "c"
        session['calculated_hst_sliders_new']["333"] = 100
    end
  end
  
	def percentage_of_heat_existing_houses
    heat_demand_existing_houses = Current.gql.query("future:V(heating_demand_with_current_insulation_households_energetic;demand)").to_f
    heat_demand_new_houses = Current.gql.query("future:V(heating_new_houses_current_insulation_households_energetic;demand)").to_f
    heat_demand_total = heat_demand_new_houses + heat_demand_existing_houses
    heat_demand_existing_houses / heat_demand_total
  end

 	def percentage_of_heat_new_houses
    1 - percentage_of_heat_existing_houses
  end

 	def percentage_of_existing_houses
 	  nr_of_old_houses = Current.setting.number_of_existing_households
    total_nr_of_houses = Current.setting.number_of_households
    nr_of_old_houses / total_nr_of_houses
  end

  def percentage_of_new_houses
    1 - percentage_of_existing_houses
  end

  def initialize_installations_sliders(house_type)
    session["calculated_hst_sliders_#{house_type}"] = {}
    InputElement.households_heating_sliders.each do |slider|
  		session["calculated_hst_sliders_#{house_type}"][slider.id.to_s] = 0
  		session["calculated_hst_sliders_#{house_type}"]["47"] = false # remove solar pv if exists
    end
  end

end
