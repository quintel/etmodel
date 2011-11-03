# == Schema Information
#
# Table name: constraints
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  name           :string(255)
#  extended_title :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  gquery_key     :string(255)
#

class Constraint < ActiveRecord::Base

  # Groups names to which a constraint must belong. Used both during
  # Constraint validation, and within the dashboard views.
  GROUPS = %w(
    unnamed_group_one
    unnamed_group_two
    unnamed_group_three
    costs
    unnamed_group_five
    unnamed_group_six
    summary
  ).freeze

  # Raised when given a blank key to Constraint.for_dashboard.
  class IllegalConstraintKey < StandardError
  end

  # Raised when searching for a constraint in Constraint.for_dashboard, and
  # the constraint does not exist.
  class NoSuchConstraint < ActiveRecord::RecordNotFound
    def initialize(key) ; @key = key end
    def message ; "No such constraint: #{@key.inspect}" end
  end

  # --------------------------------------------------------------------------

  has_paper_trail

  validates :group, :presence => true, :inclusion => GROUPS

  has_one :description, :as => :describable, :dependent => :destroy

  accepts_nested_attributes_for :description

  scope :ordered, order('id')
  scope :gquery_contains, lambda{|search| where("`gquery_key` LIKE ?", "%#{search}%")}

  # --------------------------------------------------------------------------


  # Given an array of keys, returns the Constraints which match those keys.
  #
  # `for_dashboard` will return the constraints in the same order in which
  # the keys were given.
  #
  # @param  [Array(String)] keys An array of Constraint keys.
  # @return [Array(Constraint)]
  #
  # @raise [IllegalConstraintKey]
  #   Raised if one of the given keys is blank.
  # @raise [NoSuchConstraint]
  #   Raised if one of the keys did not match a Constraint in the DB.
  #
  def self.for_dashboard(keys)
    raise IllegalConstraintKey if keys.any?(&:blank?)

    constraints = Constraint.where(:key => keys.uniq)

    # Maps the given keys to the retrieved constraints.
    keys.to_enum.with_index.each_with_object([]) do |(key, index), ordered|
      if constraint = constraints.detect { |c| c.key == key }
        ordered[index] = constraint
      else
        raise NoSuchConstraint.new(key)
      end
    end
  end

end
