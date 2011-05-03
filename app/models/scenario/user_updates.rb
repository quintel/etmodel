##
# Update statements. 
# Handling of user input
#
class Scenario < ActiveRecord::Base



  attr_writer :update_statements

  def update_statements
    @update_statements ||= {}
  end


  ##
  # TODO fix
  # @untested 2011-01-24 seb
  #
  def update_input_elements_for_api(params)
    input_element_ids = params.keys
    input_element_ids.each do |key|
      input_element = InputElement.where(['id = ? or `key` = ?', key,key]).first
      
      if params[key] == 'reset'
        delete_from_user_values(input_element.id)
      elsif value = params[key].to_f
        if input_element.id == 335
          number_of_households = Current.scenario.area.number_households * ((1+(value/input_element.factor)) ** Current.scenario.years)
        end
        # To prevent javascript hacking for disabled sliders we do an extra check. This is needed for the transition price
        unless input_element.disabled
          update_input_element(input_element, value)
        end

      end
    end
    
    add_update_statements(lce.update_statements)
  end


  ##
  # TODO REFACTOR fix
  # @untested 2011-01-24 seb
  #
  def update_input_elements(params)

    input_element_ids = params.keys.select{|key| key.match(/^\d+$/) }
    InputElement.find(input_element_ids).each do |input_element|
      value = params[input_element.id.to_s].to_f
      if input_element.id == 335
        number_of_households = Current.scenario.area.number_households * ((1+(value/input_element.factor)) ** Current.scenario.years)
      end
      # To prevent javascript hacking for disabled sliders we do an extra check. This is needed for the transition price
      unless input_element.disabled
        update_input_element(input_element, value)
      end
      
    end
    add_update_statements(lce.update_statements)
  end

  ##
  # This method sends the key values to the gql using the input element attr. 
  # Also it fills an array with input elements which must be updated after the calculation
  #
  # @param input_element <Object> the updated input element
  # @param value <Float> the posted value
  #
  # @tested 2010-12-06 seb
  # 
  def update_input_element(input_element, value)
    store_user_value(input_element, value)
    add_update_statements(input_element.update_statement(value))
  end

  ##
  # add_update_statements does not persist the slider value.
  # ie. if you update a scenario with add_update_statements the changes
  # are made (and persist), but it does not affect a slider in the UI.
  #
  # Use this method only if there are some sort of "hidden" updates.
  #
  # @param [Hash] update_statement_hash
  #   {'converters' => {'converter_key' => {'update' => value}}}
  #
  # @tested 2010-12-06 seb
  #
  def add_update_statements(update_statement_hash)
    if Current.gql_calculated?
      raise "Update statements are ignored after the GQL has finished calculating. \nStatement: \n#{update_statement_hash.inspect}" 
    end
    # This has to be self.update_statements otherwise it doesn't work
    self.update_statements = self.update_statements.deep_merge(update_statement_hash)
  end

  ##
  # Stores the user value in the session.
  #
  # @param [InputElement] input_element
  # @param [Flaot] value
  # @return [Float] the value
  #
  # @tested 2010-11-30 seb
  #
  def store_user_value(input_element, value)
    key = input_element.id
    self.user_values = self.user_values.merge key => value 
    value
  end


  ##
  # @tested 2010-11-30 seb
  #
  def user_value_for(input_element)
    user_values[input_element.id]
  end

  ##
  # TODO fix this, it's weird
  #
  # Holds all values chosen by the user for a given slider. 
  # Hash {input_element.id => Float}, e.g.
  # {3=>-1.1, 4=>-1.1, 5=>-1.1, 6=>-1.1, 203=>1.1, 204=>0.0}
  #
  # @tested 2010-11-30 seb
  #
  def user_values
    self[:user_values] ||= {}.to_yaml
    YAML::load(self[:user_values])
  end

  ##
  # Sets the user_values.
  #    
  # @untested 2010-12-22 jape
  #    
  def user_values=(values)
    raise ArgumentError.new("You must set a hash: " + values.inspect) if !values.kind_of?(Hash)
    self[:user_values] = values.to_yaml
  end


  ##
  # Deletes a uesr_value completely
  #
  # @untested 2010-12-22 seb
  #
  def delete_from_user_values(id)
    values = user_values
    values.delete(id)
    self.user_values = values
  end

  ##
  # Builds update_statements from user_values that are readable by the GQl. 
  #
  # @param [Boolean] load_as_municipality
  #
  # @untested 2010-12-06 seb
  #
  def build_update_statements(load_as_municipality)
    user_values.each_pair do |id, value|
      build_update_statements_for_element(load_as_municipality, id, value)
    end
  end

  ##
  # Called from build_update_statements
  #
  # @param [Boolean] load_as_municipality
  # @param [Integer] id InputElement#id
  # @param [Float] value user value
  #
  # @tested 2010-12-06 seb
  #
  def build_update_statements_for_element(load_as_municipality, id, value)

    input_element = InputElement.find(id)
    if load_as_municipality and scale_factor = scale_factor_for_municipality(input_element)
      value /= scale_factor
    end
    update_input_element(input_element, value)

  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("WARNING: Scenario loaded, but InputElement nr.#{id} was not found")    
  end


  ##
  # Returns the scale factor for the municipality. Nil if not scaled
  #
  # @param [InputElement] input_element
  # @return [Float, nil] the scale factor or nil if not scaled.
  #
  # @tested 2010-12-06 seb
  #
  def scale_factor_for_municipality(input_element)
    return nil if input_element.locked_for_municipalities.blank?
    if input_element_scaled_for_municipality?(input_element)
      electricity_country = area_country.current_electricity_demand_in_mj
      electricity_region = area_region.current_electricity_demand_in_mj
      (electricity_country / electricity_region).to_f
    end
  end

  ##
  # Does the input_element have to be scaled?
  #
  # @param [InputElement] input_element
  # @return [Boolean]
  #
  # @tested 2010-12-06 seb
  #
  def input_element_scaled_for_municipality?(input_element)
    # TODO move to InputElement as no scenario state is used anymore
    input_element.slide.andand.controller_name == 'supply' || input_element.slide.contains_chp_slider?
  end
end