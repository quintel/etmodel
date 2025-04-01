# frozen_string_literal: true

FactoryBot.define do
  factory :featured_scenario do
    sequence(:saved_scenario_id) { |n| n }
    group { 'group' }
    area_code { 'nl2019' }
    end_year { 2050 }
    version { '10.01' }
    title_en { 'English title' }
    title_nl { 'Dutch title' }
    author { 'Author' }
  end
end
