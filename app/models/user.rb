# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  email              :string(255)      not null
#  company_school     :string(255)
#  allow_news         :boolean          default(TRUE)
#  heared_first_at    :string(255)      default("..")
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)      not null
#  perishable_token   :string(255)      not null
#  login_count        :integer          default(0), not null
#  failed_login_count :integer          default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  role_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  phone_number       :string(255)
#  group              :string(255)
#

class User < ActiveRecord::Base
  has_many :saved_scenarios, :dependent => :destroy
  has_many :predictions
  belongs_to :role
  attr_protected :role_id #To refrain Hackers from using mass assignment when creating new account

  validates_format_of   :phone_number, 
                        :message => " is niet goed ingevuld.",
                        :with => /^[\(\)0-9\- \+\.]{10,20}$/,
                        :if => Proc.new { |o| !o.phone_number.nil? }

  validates_presence_of :name

  acts_as_authentic
  
  scope :ordered, order('name')

  def admin?
    role.try(:name) == "admin"
  end
  
  def backend_label
    "#{name} - #{email}"
  end
end
