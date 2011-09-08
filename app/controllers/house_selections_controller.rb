class HouseSelectionsController < ApplicationController
  def tool
    clear_session
    render :layout => false
  end
  
  def set
    @gql = Api::Client.new
    @gql.api_session_id = Current.setting.api_session_id
    house_type  = params[:type]
    house_label = params[:label]
    session['calculated_hst_sliders']  ||= {}
    session["house_label_#{house_type}"] = house_label
    if labels_ready_to_calculate?
      run_gqueries
      set_insulation_slider(session["house_label_new"],"new")
      set_insulation_slider(session["house_label_existing"],"existing")
      update_installation_sliders
      @perc_new_houses      = (percentage_of_new_houses * 100).round(1)
      @perc_existing_houses = (percentage_of_existing_houses * 100).round(1)

      render :update do |page|
        page["#house_selection"].html(render "house_selections/result")
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
  
  def apply
    render :update do |page|
      page.call "close_fancybox"
      session['calculated_hst_sliders'].each_with_index do |slider,i|
        page << "input_elements.inputElements[#{slider[0]}].set({ user_value : #{slider[1]} });"
      end
    end
  end

  def clear
    clear_session
    render :update do |page|
      page['#house_selection'].html( render "select")
    end
  end

  private

    def clear_session
      session["house_label_new"] = nil
      session["house_label_existing"] = nil
    end

    def labels_ready_to_calculate?
      session["house_label_new"] && session["house_label_existing"]
    end
    
    def run_gqueries
      @gql.queries = [
        "present:DIVIDE(V(local_solar_pv_grid_connected_energy_energetic;output_of_electricity),Q(potential_roof_pv_production))",
        "future:V(heating_demand_with_current_insulation_households_energetic;demand)",
        "future:V(heating_new_houses_current_insulation_households_energetic;demand)",
        "future:AREA(number_of_existing_households)",
        "future:AREA(number_households)"
      ]
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
      new_percent      = percentage_of_heat_new_houses
      session["calculated_hst_sliders_existing"].each do |slider|
        if slider.first == "47"
          average_share = set_solar_pv_slider
        else
          existing_share = slider.last * existing_percent
          new_share      = session["calculated_hst_sliders_new"][slider.first] * new_percent
          average_share  = existing_share + new_share
        end
        session['calculated_hst_sliders'][slider.first.to_s] = average_share
      end
    end
  

    #this method updates the solar pv
    def set_solar_pv_slider
      query = "present:DIVIDE(V(local_solar_pv_grid_connected_energy_energetic;output_of_electricity),Q(potential_roof_pv_production))"
      current_pv = @gql.simple_query(query)
      existing_pv = (session['calculated_hst_sliders_existing']["47"] ? session['calculated_hst_sliders_existing']["47"] : current_pv) * percentage_of_existing_houses
      new_pv = (session['calculated_hst_sliders_new']["47"] ? session['calculated_hst_sliders_new']["47"] : current_pv) * percentage_of_new_houses
    
      return existing_pv + new_pv
    end
  
    # this method updates the insulation sliders
    def set_insulation_slider(lbl,house_type)
      if house_type == 'new'
        value = case lbl
          when 'aaa' then 5
          when 'aa'  then 4
          when 'a'   then 3.5
          when 'b'   then 3
          when 'c'   then 2.5
        end
      elsif house_type == 'existing'
        value = case lbl
          when 'a' then 2.8
          when 'b' then 2.6
          when 'c' then 2.4
          when 'd' then 2
          when 'e' then 1.5
        end
      end
      slider_id = (house_type == "existing" ? 336 : 337)
      session['calculated_hst_sliders'][slider_id.to_s] = value
    end
  
    ####### HELPER METHODS #########
  
    def set_existing_installations
      case session["house_label_existing"]
        when "a"
          session['calculated_hst_sliders_existing']["51"]  = 55
          session['calculated_hst_sliders_existing']["339"] = 30
          session['calculated_hst_sliders_existing']["48"]  = 15
          session['calculated_hst_sliders_existing']["47"]  = 100
        when "b"
          session['calculated_hst_sliders_existing']["51"]  = 55
          session['calculated_hst_sliders_existing']["333"] = 30
          session['calculated_hst_sliders_existing']["48"]  = 15
        when "c"
          session['calculated_hst_sliders_existing']["333"] = 85
          session['calculated_hst_sliders_existing']["48"]  = 15
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
          session['calculated_hst_sliders_new']["48"]  = 15
          session['calculated_hst_sliders_new']["47"]  = 100
        when "aa"
          session['calculated_hst_sliders_new']["338"] = 85
          session['calculated_hst_sliders_new']["48"]  = 15
          session['calculated_hst_sliders_new']["47"]  = 50
        when "a"
          session['calculated_hst_sliders_new']["338"] = 100
        when "b"
          session['calculated_hst_sliders_new']["333"] = 100
        when "c"
          session['calculated_hst_sliders_new']["333"] = 100
      end
    end
  
    def percentage_of_heat_existing_houses
      query = "future:V(heating_demand_with_current_insulation_households_energetic;demand)"
      heat_demand_existing_houses = @gql.simple_query(query)
      query = "future:V(heating_new_houses_current_insulation_households_energetic;demand)"
      heat_demand_new_houses = @gql.simple_query(query)
      heat_demand_total = heat_demand_new_houses + heat_demand_existing_houses
      heat_demand_existing_houses / heat_demand_total
    end

    def percentage_of_heat_new_houses
      1 - percentage_of_heat_existing_houses
    end

    def percentage_of_existing_houses
      query = "future:AREA(number_of_existing_households)"
      nr_of_old_houses = @gql.simple_query(query)
      query = "future:AREA(number_households)"
      total_nr_of_houses = @gql.simple_query(query)
      nr_of_old_houses / total_nr_of_houses
    end

    def percentage_of_new_houses
      1 - percentage_of_existing_houses
    end

    def initialize_installations_sliders(house_type)
      session["calculated_hst_sliders_#{house_type}"] = {}
      ## TODO: refactor households_heating_sliders 
      InputElement.households_heating_sliders.each do |slider|
        session["calculated_hst_sliders_#{house_type}"][slider.id.to_s] = 0
        session["calculated_hst_sliders_#{house_type}"]["47"] = false # remove solar pv if exists
      end
    end
end
