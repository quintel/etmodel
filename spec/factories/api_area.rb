FactoryBot.define do
  factory :api_area, class: Api::Area do
    area_code { 'nl' }
    analysis_year { 2015 }
  end
end
