# frozen_string_literal: true

module AreaDependent
  # Load Areadependencies to ActiveRecord::Base descendents
  module ActiveRecord
    def area_dependent
      dependent_on = area_dependency&.dependent_on
      return false if dependent_on.blank?

      dependent_on ? !Current.setting.area.attributes[dependent_on] : false
    end
    alias_method :not_allowed_in_this_area, :area_dependent
  end

  # Load Areadependencies to YModel::Base descendents
  module YModel
    def area_dependent
      return false unless respond_to?(:dependent_on)
      return false if dependent_on.blank?

      dependent_on ? !Current.setting.area.attributes[dependent_on] : false
    end

    alias_method :not_allowed_in_this_area, :area_dependent
  end
end
