Factory.define :converter, :class => :converter do |converter|
  converter.name {"converter_name"}
  converter.converter_id 1
end

Factory.define :converter_demand, :class => :converter do |converter|
  converter.name {"converter_name"}
  converter.demand { 10**9  }
end
