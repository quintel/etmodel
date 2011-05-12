Factory.define :output_element_serie do |f|
  f.association :output_element, :factory => :output_element
  f.gquery 'gquery_foobar'
end