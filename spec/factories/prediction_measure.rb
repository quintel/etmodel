Factory.define :prediction_measure do |f|
  f.association :prediction, :factory => :prediction
  f.name "This a name of the measure"
  f.impact 10
  f.cost	15
  f.year_start 2015
  f.actor "government"
  f.description "This is a nice test description for prediction measure"
end