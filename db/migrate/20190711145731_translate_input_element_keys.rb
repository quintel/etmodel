class TranslateInputElementKeys < ActiveRecord::Migration[5.2]
  def dictionary
    [
      ["households_number_of_apartments"      , "households_apartments_share"],
      ["households_number_of_corner_houses"   , "households_corner_houses_share"],
      ["households_number_of_detached_houses" , "households_detached_houses_share"],
      ["households_number_of_households"      , "households_number_of_residences"],
      ["households_number_of_semi_detached_houses", "households_semi_detached_houses_share"],
      ["households_number_of_terraced_houses", "households_terraced_houses_share"],
    ]
  end

  def up
    dictionary.each do |item|
      element = InputElement.find_by(key: item[0])
      element&.update_attributes(key: item[1])
    end
  end

  def down
    dictionary.each do |item|
      element = InputElement.find_by(key: item[1])
      element&.update_attributes(key: item[0])
    end
  end
end
