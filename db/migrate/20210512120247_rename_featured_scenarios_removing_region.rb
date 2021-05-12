class RenameFeaturedScenariosRemovingRegion < ActiveRecord::Migration[6.0]
  def up
    FeaturedScenario.where(group: 'national').each do |scenario|
      if scenario.saved_scenario.area_code == 'UKNI01_northern_ireland'
        scenario.group = 'northern_ireland'
      end

      [:en, :nl].each do |locale|
        new_title = scenario.public_send("title_#{locale}")
        split = new_title.split(' - ', 2)

        if split.first == I18n.t("areas.#{scenario.saved_scenario.area_code}", locale: locale)
          new_title = split[1]
        end

        if new_title.start_with?('II3050')
          new_title = new_title.gsub(/^II3050/, 'II3050 - ')
        end

        scenario.public_send("title_#{locale}=", new_title)
      end

      scenario.save!
    end
  end

  def down
    FeaturedScenario.where(group: %w[national northern_ireland]).each do |scenario|
      scenario.group = 'national'

      [:en, :nl].each do |locale|
        title = scenario.public_send("title_#{locale}")
        title = title.gsub(/^II3050 - /, 'II3050')
        region_name = I18n.t("areas.#{scenario.saved_scenario.area_code}", locale: locale)

        scenario.public_send("title_#{locale}=", "#{region_name} - #{title}")
      end

      scenario.save!
    end
  end
end
