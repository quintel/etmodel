# frozen_string_literal: true

# This code is meant to hold behaviour and data concerning the PICO area types.
#
# The following javascript objects come from the site below.
#   view-source:https://pico.geodan.nl/pico/minimap/map_windmodule.html

# rubocop:disable Metrics/LineLength
#   //areatype:'land',areaname:'Nederland',selectfield:'', selectvalue:''
#   //areatype:'provincie', areaname:'Friesland', selectfield:'prov_code', selectvalue:'21'
#   //areatype:'resgebied', areaname:'Twente', selectfield:'res_code', selectvalue:'25'
#   //areatype:'gemeente', areaname:'Apeldoorn', selectfield:'gem_code', selectvalue:'0200'
#   //areatype:'gemeente', areaname:'Neder-Betuwe', selectfield:'gem_code', selectvalue:'1740'
# rubocop:enable Metrics/LineLength

# Selectfields
#    - prov_code, Source is CBS and should match between ETM and PICO.
#    - gem_code, BAG mucipal ID and should match between ETM and PICO.
#    - red_code, some unknown identifier. Doesn't match between ETM and PICO

module Embeds
  module Pico
    # no-doc
    module AreaType
      class UnmatchableSelectValueError < StandardError; end

      # This struct is the abstract representation of a pico areatype
      #
      # key:                   a name for an area type.
      #
      # select_field:          key of some type that is needed for interfacing
      #                        with pico. We use this code to infer it from key.
      #
      # matcher:               A regex to detect what area type an Api::Area is
      #                        from its #area.
      #
      # select_field_stripper: Strategy for creating a select_field from
      #                        an Api::Area#area.

      type =
        Struct.new(:key, :select_field, :matcher, :select_field_stripper) do
          def select_value_from(area)
            select_field_stripper.call(area)
          end
        end

      Municipality = type.new(:gemeente, :gem_code, /\AGM/, proc do |area|
        area.split('_').first.sub('GM', '')
      end).freeze

      Province = type.new(:provincie, :prov_code, /\APV/, proc do |area|
        area.split('_').first.sub('PV', '')
      end).freeze

      Country = type.new(:land, '', 'nl', proc { '' }).freeze

      Res = type.new(:res, :res_code, /\ARES/, proc do
        raise UnmatchableSelectValueError
      end).freeze

      ALL = [Municipality, Province, Res, Country].freeze
    end
  end
end
