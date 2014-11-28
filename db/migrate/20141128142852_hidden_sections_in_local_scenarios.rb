class HiddenSectionsInLocalScenarios < ActiveRecord::Migration
  HIDE_ITEMS = [
    [:sidebar_item,  :area],
    [:sidebar_item,  :electricity_import_export],
    [:sidebar_item,  :fuel_production],
    [:input_element, :transport_useful_demand_planes],
    [:input_element, :transport_useful_demand_ships]
  ]

  def up
    HIDE_ITEMS.each do |(type, key)|
      thing = __send__(type, key)
      dep   = thing.area_dependency || thing.build_area_dependency

      dep.update_attributes!(dependent_on: 'is_national_scenario')
    end
  end

  def down
    HIDE_ITEMS.each do |(type, key)|
      __send__(type, key).area_dependency
        .update_attributes!(dependent_on: nil)
    end
  end

  private

  def input_element(key)
    InputElement.where(key: key).first!
  end

  def sidebar_item(key)
    SidebarItem.where(key: key).first!
  end
end
