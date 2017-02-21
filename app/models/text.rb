# == Schema Information
#
# Table name: texts
#
#  id               :integer          not null, primary key
#  key              :string(255)
#  content_en       :text
#  content_nl       :text
#  created_at       :datetime
#  updated_at       :datetime
#  title_en         :string(255)
#  title_nl         :string(255)
#  short_content_en :text
#  short_content_nl :text
#

class Text < ActiveRecord::Base
  validates :key, presence: true

  def title
    t :title
  end

  def content
    t :content
  end

  def short_content
    t :short_content
  end

  def t(attr_name)
    send("#{attr_name}_#{I18n.locale.to_s.split('-').first}")
  end
end

