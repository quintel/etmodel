# == Schema Information
#
# Table name: general_user_notifications
#
#  id              :integer(4)      not null, primary key
#  key             :string(255)
#  notification_nl :string(255)
#  notification_en :string(255)
#  active          :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class GeneralUserNotification < ActiveRecord::Base
  scope :active, where(:active => true)
  
  def text
    I18n.locale.to_sym == :en ? notification_en : notification_nl
  end
end
