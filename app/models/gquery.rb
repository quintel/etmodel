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
  validate :validate_query_parseable
  # belongs_to :gquery_group
  has_and_belongs_to_many :gquery_groups
  after_save :reload_cache

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


  ##
  # The GqlParser currently does not work with whitespace.
  # So we remove all whitespace before running the query
  #
  # Note: (sb) Alternatively we could also clean the query
  # in the GQL engine. But then it would run for every (sub)query.
  # Instead we memoize (see self.gquery_hash) the clean queries
  # once and for all, saving us a few milliseconds per request.
  #
  # ejp- cleaning algorithm is encapsulated in Gql:GqueryCleanerParser
  def parsed_query
    @parsed_query ||= Gql::GqueryCleanerParser.clean_and_parse(query)
  end

  @@gquery_hash = nil
  ##
  # Memoize gquery_hash
  #
  def self.gquery_hash
    @@gquery_hash ||= build_gquery_hash
  end

  def self.build_gquery_hash
    self.all.inject({}) {|hsh,gquery| hsh.merge(gquery.key => gquery)}
  end

  def self.load_gquery_hash_from_marshal(filename)
    raise "File '#{filename}' does not exist" unless File.exists?(filename)
    @@gquery_hash = Marshal.load(File.read(filename))
  end

private

  ##
  # Method to invalidate the memoized gquery_hash.
  #
  def reload_cache
    @@gquery_hash = nil
  end


  def validate_query_parseable
    if Gql::GqueryCleanerParser.check_query(self[:query]).nil?
      errors.add(:query, "cannot be parsed")
      false
    else
      true
    end
  end


end


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

