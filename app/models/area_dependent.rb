module AreaDependent

  def area_dependent
    dependent_on = area_dependency.andand.dependent_on
    dependent_on ? ( !(Current.scenario.area).send("#{dependent_on}")) : false
  end
end
