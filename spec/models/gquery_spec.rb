require 'spec_helper'

describe Gquery do
  describe "#new" do
    it "should remove whitespace from key" do
      gquery = Gquery.create(:key => " foo \t ", :query => "SUM(1,1)")
      gquery.key.should == 'foo'
    end
  end

end
# == Schema Information
#
# Table name: gqueries
#
#  id                   :integer(4)      not null, primary key
#  key                  :string(255)
#  query                :text
#  name                 :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  not_cacheable        :boolean(1)      default(FALSE)
#  usable_for_optimizer :boolean(1)      default(FALSE)
#

