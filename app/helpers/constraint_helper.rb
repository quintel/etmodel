module ConstraintHelper
  # Public: The path to a map image representing the region. Derived datasets
  # fall back to the NL image.
  def area_map_path(suffix = nil)
    country = (
      area_setting.try(:base_dataset) ||
      area_setting.area
    ).to_s.gsub(/\d+$/, '')

    country = country.split('-')[0] if country.include?('-')

    "/assets/maps/#{country}_map#{suffix}.png"
  end

  def area_setting
    Current.setting.area
  end
end
