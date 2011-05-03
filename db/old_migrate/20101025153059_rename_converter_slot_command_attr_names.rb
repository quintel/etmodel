class RenameConverterSlotCommandAttrNames < ActiveRecord::Migration
  def self.up
    InputElement.find_each do |input_element|
      if input_element.attr_name.andand.match(/^(.*)_(input|output)_conversion_conversion$/)
        input_element.attr_name.gsub('_conversion_conversion', '_conversion_value')
        input_element.save
      end
    end
#    BlackboxScenario.each do |bbs|
#      bbs.user_updates = bbs.user_updates.to_yaml.gsub('_conversion_conversion', '_conversion_value')
#      bbs.save
#    end
  end

  def self.down
  end
end
