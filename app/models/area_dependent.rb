module AreaDependent
  def area_dependent
    dependent_on = area_dependency&.dependent_on
    return false if dependent_on.blank?

    dependent_on ? !Current.setting.area.attributes[dependent_on] : false
  end
  alias_method :not_allowed_in_this_area, :area_dependent
end
