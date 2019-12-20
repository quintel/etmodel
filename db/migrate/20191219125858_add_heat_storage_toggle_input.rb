class AddHeatStorageToggleInput < ActiveRecord::Migration[5.2]
  def up
    sidebar_item = SidebarItem.where(key: 'heat').first!
    output_element = OutputElement.where(key: 'collective_heat_mekko').first!

    slide = Slide.create!(
      key: 'supply_heat_network_storage_toggle',
      sidebar_item: sidebar_item,
      output_element: output_element,
      position: sidebar_item.slides.ordered.last.position + 1,
      description_attributes: {
        content_en: <<-TEXT.strip_heredoc,
          Scenarios with large amounts of "must-run" heat production will often
          have considerable excesses of heat. Storage allows you to preserve
          this heat for later use (subject to some losses), reducing the amount
          of dispatchable capacity required during large spikes in demand.
        TEXT
        content_nl: <<-TEXT.strip_heredoc
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam rutrum
          in nunc quis feugiat. Fusce ut mauris orci. Ut facilisis quam ex, in
          pellentesque neque volutpat ut. Aenean pulvinar ligula sed ullamcorper
          vestibulum. Aliquam hendrerit hendrerit nulla.
        TEXT
      }
    )

    InputElement.create!(
      key: 'heat_storage_enabled',
      unit: 'boolean',
      slide: slide,
      step_value: 1,
      position: 1
    )
  end

  def down
    InputElement.where(key: 'heat_storage_enabled').first!.destroy!
    Slide.where(key: 'supply_heat_network_storage_toggle').first!.destroy!
  end
end
