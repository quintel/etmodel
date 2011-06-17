Factory.define :tab do |f|
  f.sequence(:key) {|n| "tab_#{n}" }
end