module AreaDependent

  def area_dependent
    dependent_on = area_dependency.andand.dependent_on
    dependent_on ? ( !(Current.setting.area).send("#{dependent_on}")) : false
  end
end
