# frozen_string_literal: true

# DashboardItems are shown in the dashboard that appears on the bottom of the
# pages in the etm play environnement
class DashboardItem < YModel::Base
  include AreaDependent::YModel
  source_file 'config/interface/dashboard_items.yml'
  index_on :key
  belongs_to :output_element

  # Groups names to which a dashboard item must belong. Used within the
  # dashboard views.
  GROUPS = %w[
    energy_use
    co2
    import
    costs
    footprint
    renewable
    summary
  ].freeze

  # Raised when given a blank key to DashboardItem.for_dashboard.
  class IllegalDashboardItemKey < StandardError
  end

  # Raised when searching for a dashboard item in DashboardItem.for_dashboard, and
  # the dashboard item does not exist.
  class NoSuchDashboardItem < ActiveRecord::RecordNotFound
    def initialize(key)
      @key = key
    end

    def message
      "No such dashboard item: #{@key.inspect}"
    end
  end

  # --------------------------------------------------------------------------

  # CLASS METHODS ------------------------------------------------------------

  class << self
    # Scopes

    def ordered
      all.sort_by(&:position)
    end

    def default
      all.reject { |di| di.position.nil? }
    end

    def enabled
      all.reject(&:disabled)
    end

    def gquery_contains(search)
      all.select { |di| di.gquery_key.include?(search) }
    end

    def ordered_default
      all.reject { |di| di.position.nil? || di.disabled }.sort_by(&:position)
    end

    # Given an array of keys, returns the DashboardItems which match those keys.
    #
    # `for_dashboard` will return the dashboard items in the same order in which
    # the keys were given.
    #
    # @param  [Array(String)] keys An array of DashboardItem keys.
    # @return [Array(DashboardItem)]
    #
    # @raise [IllegalDashboardItemKey]
    #   Raised if one of the given keys is blank.
    # @raise [NoSuchDashboardItem]
    #   Raised if one of the keys did not match a DashboardItem in the ymls,
    #   or if the dashboard item is disabled
    #
    def for_dashboard!(keys)
      return DashboardItem.default if !keys || keys.none?

      raise IllegalDashboardItemKey if keys.any?(&:blank?)

      keys.uniq.map do |key|
        dashboard_item = DashboardItem.find(key)
        unless dashboard_item && !dashboard_item.disabled
          raise(NoSuchDashboardItem, key)
        end

        dashboard_item
      end
    end

    # Given an array of keys, returns the DashboardItems which match those keys. If
    # one or more dashboard items do not exist, the default dashboard items are returned
    # instead.
    #
    # @see DashboardItem.for_dashboard!
    def for_dashboard(keys)
      for_dashboard!(keys)
    rescue IllegalDashboardItemKey, NoSuchDashboardItem
      DashboardItem.default
    end
  end

  # INSTANCE METHODS ---------------------------------------------------------

  # Creates a JSON representation of the DashboardItem. Contains only the id,
  # key, Gquery key and the dependencies.
  #
  # @return [Hash{String => Object}]
  #
  def as_json(*)
    %w[key gquery_key dependent_on].index_with { |k| send(k) }
  end

  def description
    I18n.t("dashboard_items.#{key}.description", default: '')
  end
end
