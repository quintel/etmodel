class UpdateLinkOnSlideCo2Sheets < ActiveRecord::Migration[5.2]
  def change
    description = Slide.find_by_key(:data_visuals_co2_sheet).description

    find = 'scenario=true'
    replace = 'scenario=%{scenario_id}'

    reversible do |dir|
      dir.up   { update_description(description, find, replace) }
      dir.down { update_description(description, replace, find) }
    end
  end

  def update_description(description, find, replace)
    description.content_en = description.content_en.gsub(find, replace)
    description.content_nl = description.content_nl.gsub(find, replace)

    description.save(validate: false)
  end
end
