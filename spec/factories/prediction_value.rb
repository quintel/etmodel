Factory.define :prediction_value do |f|
  f.association :prediction, :factory => :prediction
  f.min 2
  f.best 3
  f.max 4
  f.year 2050
end