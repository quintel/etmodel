# == Schema Information
#
# Table name: constraints
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  gquery_key :string(255)
#  group      :string(25)       not null
#  position   :integer
#

# TODO: this should be renamed, DashboardItem would be a better name
#
class Constraint < ActiveRecord::Base

  include AreaDependent

  # Groups names to which a constraint must belong. Used both during
  # Constraint validation, and within the dashboard views.
  GROUPS = %w(
    energy_use
    co2
    import
    costs
    footprint
    renewable
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

  validates :group, presence: true, inclusion: GROUPS

  belongs_to :output_element
  has_one :description, as: :describable, dependent: :destroy
  has_one :area_dependency, as: :dependable, dependent: :destroy

  accepts_nested_attributes_for :description, :area_dependency

  scope :ordered, -> { order('position') }
  scope :default, -> { where('position IS NOT NULL') }
  scope :enabled, -> { where(disabled: false) }

  scope :gquery_contains, ->(search) { where("`gquery_key` LIKE ?", "%#{search}%") }

  # CLASS METHODS ------------------------------------------------------------

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
    return Constraint.default.ordered if !keys || keys.none?

    raise IllegalConstraintKey if keys.any?(&:blank?)

    constraints = Constraint.enabled.where(key: keys.uniq)

    # Maps the given keys to the retrieved constraints.
    keys.to_enum.with_index.each_with_object([]) do |(key, index), ordered|
      if constraint = constraints.detect { |c| c.key == key }
        ordered[index] = constraint
      else
        raise NoSuchConstraint.new(key)
      end
    end
  end

  # INSTANCE METHODS ---------------------------------------------------------

  # Creates a JSON representation of the Constraint. Contains only the id,
  # key and Gquery key. Removes the root namespace ('constraint').
  #
  # @return [Hash{String => Object}]
  #
  def as_json(*)
    json = super(only: [ :id, :key, :gquery_key ])

    if ActiveRecord::Base.include_root_in_json
      json['constraint']
    else json end
  end

end
