require 'spec_helper'

describe Current do
  describe "#backcasting_enabled" do
    it "returns true if the current locale is nl" do
      I18n.should_receive(:locale).and_return(:nl)
      expect(Current.backcasting_enabled).to be_true
    end

    it "returns false if current locale is not nl" do
      I18n.should_receive(:locale).and_return(:en)
      expect(Current.backcasting_enabled).to be_false
    end
  end
end
