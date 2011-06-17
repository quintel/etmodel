class Interface < ActiveRecord::Base
  validates :key, :presence => true
  validates :key, :uniqueness => true
end
