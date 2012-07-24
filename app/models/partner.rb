# == Schema Information
#
# Table name: partners
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  url              :string(255)
#  country          :string(255)
#  time             :integer(4)
#  repeat_any_other :boolean(1)      default(FALSE)
#  subheader        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  place            :string(255)     default("right")
#  long_name        :string(255)
#  partner_type     :string(255)     default("general")
#

class Partner < ActiveRecord::Base
  has_one :description, :as => :describable

  scope :country, lambda {|country| where(:country => country) }
  scope :place, lambda {|position| where(:place => position) }
  scope :left, where(:place => "left")
  scope :right, where(:place => "right")
  scope :unique, group("name")
  scope :include_descriptions, includes(:description)

  accepts_nested_attributes_for :description

  ##
  # TODO: Handle the case when a partner has strange characters in the name.
  #       It's probably easiest to add a new attribute 'slug' to partners that
  #       holds a url suitable name.
  #
  def self.find_by_slug(name)
    find_by_name(name.to_s.downcase)
  end

  # If available will return the country specific partner item
  def self.find_by_slug_localized(name, country = nil)
    where(:name => name.downcase, :country => country).first || find_by_slug(name)
  end

  def description?
    self.description
  end

  def name_or_long_name
    self.long_name ? self.long_name : self.name
  end

  def logo
    "/assets/partners/#{name.downcase.gsub(' ', '_')}.png"
  end

  def footer_logo
    "/assets/partners/#{name.downcase.gsub(' ', '_')}-inner.png"
  end

  def link
    has_local_page? ? "/partners/#{name.downcase}" : url
  end

  # Returns true if we have a local page about the partner
  def has_local_page?
    description && description.content.present?
  end
end
