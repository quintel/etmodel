class RenameNl2019DatasetToNl < ActiveRecord::Migration[6.0]
  def up
    say_with_time 'Rename nl dataset to nl2015' do
      SavedScenario.where(area_code: 'nl').update_all(area_code: 'nl2015')
    end

    say_with_time 'Rename nl multi-year charts to nl2015' do
      MultiYearChart.where(area_code: 'nl').update_all(area_code: 'nl2015')
    end

    say_with_time 'Rename nl2019 dataset to nl' do
      SavedScenario.where(area_code: 'nl2019').update_all(area_code: 'nl')
    end

    say_with_time 'Rename nl multi-year charts to nl2015' do
      MultiYearChart.where(area_code: 'nl2019').update_all(area_code: 'nl')
    end
  end

  def down
    say_with_time 'Rename nl dataset to nl2019' do
      SavedScenario.where(area_code: 'nl').update_all(area_code: 'nl2019')
    end

    say_with_time 'Rename nl multi-year charts to nl2019' do
      MultiYearChart.where(area_code: 'nl').update_all(area_code: 'nl2019')
    end

    say_with_time 'Rename nl2015 dataset to nl' do
      SavedScenario.where(area_code: 'nl2015').update_all(area_code: 'nl')
    end

    say_with_time 'Rename nl2015 multi-year charts to nl' do
      MultiYearChart.where(area_code: 'nl2015').update_all(area_code: 'nl')
    end
  end
end
