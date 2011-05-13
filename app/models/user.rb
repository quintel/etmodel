# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     not null
#  email              :string(255)     not null
#  company_school     :string(255)
#  allow_news         :boolean(1)      default(TRUE)
#  heared_first_at    :string(255)     default("..")
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)     not null
#  perishable_token   :string(255)     not null
#  login_count        :integer(4)      default(0), not null
#  failed_login_count :integer(4)      default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  role_id            :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  openid_identifier  :string(255)
#  phone_number       :string(255)
#  group              :string(255)
#  trackable          :string(255)     default("0")
#  send_score         :boolean(1)      default(FALSE)
#

class User < ActiveRecord::Base
  has_many :scenarios
  belongs_to :role
  attr_protected :role_id #To refrain Hackers from using mass assignment when creating new account

  validates_format_of   :phone_number, 
                        :message => " is niet goed ingevuld.",
                        :with => /^[\(\)0-9\- \+\.]{10,20}$/,
                        :if => Proc.new { |o| !o.phone_number.nil? }

  validates_presence_of :name
  # validates_length_of :phone_number, :is => 10, :message => "moet 10 cijfers zijn"
  
  # acts_as_authentic do |a|
  #     a.validates_format_of_login_field_options = {:with => LOGIN_REGEXP}
  #     a.validates_format_of_email_field_options = {:with => EMAIL_REGEXP}
  # end
  acts_as_authentic
  # no open id right now

  # HUMANIZED_ATTRIBUTES = {
  #   :name             => I18n.t("user.name"),
  #   :email            => I18n.t("user.email"),
  #   :company_school   => I18n.t("user.company_school"),
  #   :allow_news       => I18n.t("user.allow_news"),
  #   :heared_first_at  => I18n.t("user.heared_first_at"),
  #   :phone_number     => I18n.t("user.phone_number")
  # }
  
  def admin?
    self.role.andand.name == "admin"
  end

  def role_symbols
    if self.role.andand.name == "admin"
      [:admin]
    else
      [:guest]
    end
  end
  

  # no open id right now
  # private
  #
  # def map_openid_registration(registration)
  #   self.email = registration["email"] if email.blank?
  #   self.username = registration["nickname"] if username.blank?
  # end

end



