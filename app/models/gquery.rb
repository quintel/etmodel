# DEBT: remove after separation

# == Schema Information
#
# Table name: gqueries
#
#  id                   :integer(4)      not null, primary key
#  key                  :string(255)
#  query                :text
#  name                 :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  not_cacheable        :boolean(1)      default(FALSE)
#  usable_for_optimizer :boolean(1)      default(FALSE)
#

##
# A Gquery holds a specific GQL query. It mainly consists of:
# - key: other gqueries can embed this query using the key. E.g. SUM(QUERY(foo),QUERY(bar))
# - query: the GQL query in a human readable plain text format.
#
#
class Gquery < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :key
  validates_uniqueness_of :key
  validates_presence_of :query

  # belongs_to :gquery_group
  has_and_belongs_to_many :gquery_groups

  strip_attributes! :only => [:key]

  scope :containing_converter_key, lambda{|key| where("query LIKE ?", "%#{key.to_s}%") }

  scope :contains, lambda{|search| where("query LIKE ?", "%#{search}%")}

  ##
  # Returns the cleaned query for any given key.
  #
  # @param key [String] Gquery key (see Gquery#key)
  # @return [String] Cleaned Gquery
  #
  def self.get(key)
    query = gquery_hash[key]
    raise Gql::GqlError.new("Gquery.get: no query found with key: #{key}") if query.nil?
    query
  end

end


