require 'spec_helper'

describe Slide do

  describe "infrastructure" do
    before { @slide = Slide.new }
  end

end

# == Schema Information
#
# Table name: slides
#
#  id                        :integer(4)      not null, primary key
#  controller_name           :string(255)
#  action_name               :string(255)
#  name                      :string(255)
#  default_output_element_id :integer(4)
#  order_by                  :integer(4)
#  image                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  sub_header                :string(255)
#  complexity                :integer(4)      default(1)
#  sub_header2               :string(255)
#  subheader_image           :string(255)
#  key                       :string(255)
#

