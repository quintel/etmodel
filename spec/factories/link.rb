Factory.define :link do |link|
  link.parent_id 2#  {|parent| parent.association(:converter) }
  link.converter_id 3#  {|child| child.association(:converter) }
  link.carrier_id 3
  link.link_type 1
  link.excel_id 1
end

