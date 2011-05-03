class Scenario < ActiveRecord::Base

  ##############################
  # Methods to deal with groups of sliders.
  ##############################

  ##
  # If a user attempts to update a share group and the group does not
  # add up to 100% we should remove all the user_updates of any input_element
  # in that group. Otherwise this scenario will be have errors for the
  # time being (you cannot delete user_updates atm through the API).
  #
  # @untested 2011-01-22 seb
  #
  def remove_groups_and_elements_not_adding_up!(save_scenario = true)
    used_groups_not_adding_up.each do |group, elements| 
      elements.each do |element| 
        delete_from_user_values(element.id)
      end
    end
    # TODO this should probably be save_scenario
    save if Current.scenario
  end

  ##
  # @return [Boolean] true if there is a share_group that doesn't add up to 100%
  #
  # @tested 2011-01-22 seb
  #
  def used_groups_add_up?
    used_groups_not_adding_up.empty?
  end

  ##
  # Only #used_groups where elements do not add up to 100%
  #
  # @tested 2011-01-22 seb
  #
  def used_groups_not_adding_up
    used_groups.reject do |group, elements|
      v = elements.map{|e| user_values[e.id] }.compact.sum
      v > 99.99 && v < 100.01
    end
  end

  ##
  # A hash of input_element (share-) groups and their input_elements.
  #
  # @return [Hash] group name => [Array<InputElement>]
  #
  # @tested 2011-01-22 seb
  #
  def used_groups
    groups = InputElement.input_elements_grouped

    hsh = {}

    # remove groups that have no input_element in user_values
    groups.each do |group, elements| 
      if (elements.map(&:id) & user_values.keys).present?
        hsh[group] = elements
      end
    end

    hsh
  end
end