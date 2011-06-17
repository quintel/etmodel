Factory.define :interface do |f|
  f.sequence(:key) {|n| "interface_#{n}" }
end
