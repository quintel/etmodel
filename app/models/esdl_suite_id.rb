class EsdlSuiteId < ApplicationRecord
  belongs_to  :user

  validates   :id_token, presence: true
  validates   :access_token, presence: true
  validates   :refresh_token, presence: true

  def userinfo
    puts 'USERINFO REQUESTED'
    access_token.userinfo!
  end
end