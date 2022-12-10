FactoryBot.define do
  factory :api_area, class: Engine::Area do
    area { 'nl' }
    area_code { 'nl' }
    analysis_year { 2015 }
    group { 'country' }
  end
end
