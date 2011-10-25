module AreaDependent
  def area_dependent
    dependent_on = area_dependency.andand.dependent_on
    return false if dependent_on.blank?
    dependent_on ? ( !(Current.setting.area).send("#{dependent_on}")) : false
  end
end
