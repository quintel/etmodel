Factory.define :sidebar_item do |f|
  f.name 'foo'
  f.sequence(:key) {|n| "sidebar_item_#{n}" }
end