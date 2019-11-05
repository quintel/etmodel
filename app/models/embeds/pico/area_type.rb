# The following javascript code comes from
#   view-source:https://pico.geodan.nl/pico:minimap/map_windmodule.html
#
# //areatype:'land',areaname:'Nederland',selectfield:'', selectvalue:''
# //areatype:'provincie', areaname:'Friesland', selectfield:'prov_code', selectvalue:'21'
# //areatype:'resgebied', areaname:'Twente', selectfield:'res_code', selectvalue:'25'
# //areatype:'gemeente', areaname:'Apeldoorn', selectfield:'gem_code', selectvalue:'0200'
# //areatype:'gemeente', areaname:'Neder-Betuwe', selectfield:'gem_code', selectvalue:'1740'
#
# Selectfields
#  Selectfields is a requirement set by PICO. It seem to be an ENUM type used
#  to declare the key on which an area is matched.Some examples follow:
#
#   - prov_code, Source is CBS and should match between ETM and PICO.
#   - gem_code, BAG mucipal ID and should match between ETM and PICO.
#   - red_code, some unknown identifier. Doesn't match between ETM and PICO
#

module Embeds::Pico::AreaType
  class UnmatchableSelectValueError < StandardError; end
  type = Struct.new(:key, :select_field, :matcher, :select_field_stripper) do
    def get_select_value(area)
      select_field_stripper.call(area)
    end
  end

  Municipality = type.new(:gemeente, :gem_code, /\AGM/, ->(area) do
    area.split('_').first.sub("GM", "")
  end)

  Province = type.new(:provincie, :prov_code, /\APV/, ->(area) do
    area.split('_').first.sub("PV", "")
  end)

  Res = type.new(:res, :res_code, /\ARES/, ->(area) do
    raise UnmatchableSelectValueError
  end)

  Country = type.new(:land, "".freeze, "nl", ->(area){ '' })

  ALL = [Municipality, Province, Res, Country]
end
