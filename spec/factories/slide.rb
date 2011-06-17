Factory.define :slide do |f|
  f.name 'this is a slide'
  f.sequence(:key) {|n| "slide_#{n}" }
end