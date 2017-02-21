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
  has_many   :saved_scenarios, dependent: :destroy
  has_many   :predictions
  belongs_to :role

  belongs_to :teacher,  class_name: 'User'
  has_many   :students, class_name: 'User', foreign_key: 'teacher_id'

  validates_presence_of :name

  attr_accessor :teacher_email

  validate :teacher_email_exists

  def teacher_email
    self.teacher.try(:email)
  end

  def teacher_email_exists
    if @teacher_email.blank?
      self.teacher_id = nil
      return
    end

    self.teacher = User.where(email: @teacher_email).first
    unless self.teacher
      errors.add(:teacher_email, "does not exist.")
    end
  end

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha512
  end

  scope :ordered, -> { order('name') }

  def admin?
    role.try(:name) == "admin"
  end

  def backend_label
    "#{name} - #{email}"
  end

  def md5_hash
    Digest::MD5.hexdigest(created_at.to_s)
  end

end
