FactoryGirl.define do
  factory :text do
    key 'foobar'
    title_en 'Title EN'
    title_nl 'Title NL'
    content_en 'Content EN'
    content_nl 'Content NL'
    short_content_en 'Short Content EN'
    short_content_nl 'Short Content NL'
    searchable false
  end
end
