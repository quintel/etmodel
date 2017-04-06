require 'rails_helper'

describe Current do
  describe "#backcasting_enabled" do
    it "returns true if the current locale is nl" do
      expect(I18n).to receive(:locale).and_return(:nl)
      expect(Current.backcasting_enabled).to be(true)
    end

    it "returns false if current locale is not nl" do
      expect(I18n).to receive(:locale).and_return(:en)
      expect(Current.backcasting_enabled).to be(false)
    end
  end
end
