module Admin
class BaseController < ApplicationController
  layout 'admin'
  before_filter :restrict_to_admin

  # This is to remind the analysts to start using the new data interface
  #
  def deprecated_admin_area_notice
    flash[:error] = "This area is deprecated and will soon be deactivated. You can find it in the new data tool at /data"
  end

  ##
  # Marshals the object and sends it as a file to the user.
  #
  def send_marshal(object, options = {})
    options[:filename] ||= [
      object.class.name.underscore,
      (object.respond_to?(:id) ? object.id : nil),
      'marshal' 
    ].compact.join('.')

    send_data(Marshal.dump(object), :filename => options[:filename], :disposition => 'attachment')
  end

end
end