class Translation < ActiveRecord::Base
  has_paper_trail
  def content
    t(:content)
  end

  def t(attr_name)
    send("#{attr_name}_#{I18n.locale.to_s.split('-').first}")
  end
end

# == Schema Information
#
# Table name: translations
#
#  id         :integer(4)      not null, primary key
#  key        :string(255)
#  content_en :text
#  content_nl :text
#  created_at :datetime
#  updated_at :datetime
#

