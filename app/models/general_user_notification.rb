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

  def notification
    t(:notification)
  end

  def t(attr_name)
    send("#{attr_name}_#{I18n.locale.to_s.split('-').first}").andand.html_safe
  end

end
