require 'spec_helper'

module Opt
  class SliderGroupControl < SliderControl
    ##
    # overwriting inspect to not cause issues when testing with input_element mocks.
    def inspect
      "<SliderGroupControl>"
    end
  end
  
  describe SliderGroupControl do

    before do
      input_element = mock_model(InputElement, 
          :min_value => 0.0, 
          :max_value => 100.0, 
          :user_value => 50.0
      )
      @control1 = SliderGroupControl.new(input_element, 5.0)
      @control2 = SliderGroupControl.new(input_element, 5.0)
      @control3 = SliderGroupControl.new(input_element, 5.0)
      @control1.stub!(:group_sliders).and_return([@control1, @control2, @control3])
      @settings = @control1.settings
    end

    subject { @settings }
    its(:class) { should be Array }
    it { should have(5).items }

    describe "default setting" do
      before { @setting = @settings.first}
      specify { @setting.keys.should have(1).item }
      specify { @setting.keys.first.should be @control1 }
      describe "setting" do
        specify { @setting.values.first.class.should be SliderGroupSetting }
        specify { @setting.values.first.has_action?.should be_false }
      end
    end

    describe "settings" do
      before { @slider_settings = @settings[1..-1] }
      subject { @slider_settings }

      it "every other slider should have 1 up/down/none" do
        @slider_settings.all?{|s| s.keys.length == 3}.should be_true
        @slider_settings.all?{|s| s.values.select(&:has_action?).length == 2}.should be_true
        @slider_settings.all?{|s| s.values.reject(&:has_action?).length == 1}.should be_true
      end
      it "control2 has up/down/none" do
        s = @slider_settings.map{|s| s[@control2].direction }
        s.include?(:none)
        s.include?(:up)
        s.include?(:down)
      end
    end

  end
end