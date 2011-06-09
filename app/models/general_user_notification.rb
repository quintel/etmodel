class GeneralUserNotification < ActiveRecord::Base

  def notification
    t(:notification)
  end

  def t(attr_name)
    send("#{attr_name}_#{I18n.locale.to_s.split('-').first}").andand.html_safe
  end

end
