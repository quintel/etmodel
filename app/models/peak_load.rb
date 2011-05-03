##
# PeakLoad
#
class PeakLoad
  attr_reader :gql

  def initialize(gql = Current.gql)
    @gql = gql
  end

  def enabled?
    Current.setting.track_peak_load?
  end

  def grid_investment_needed?
    gql.query('future:Q(grid_investment_needed)') == true
  end

  def parts_affected
    @parts_affected ||= {
      'future:GREATER(Q(investment_cost_lv_net_total),0)' => 'lv',
      'future:GREATER(Q(investment_cost_mv_lv_transformer_total),0)' => 'mv-lv',
      'future:GREATER(SUM(Q(investment_cost_mv_distribution_net_total),Q(investment_cost_mv_transport_net_total)),0)' => 'mv',
      'future:GREATER(Q(investment_cost_hv_mv_transformer_total),0)' => 'hv-mv',
      'future:GREATER(Q(investment_cost_hv_net_total),0)' => 'hv'
    }.map do |query, part_affected|
      (gql.query(query) == true) ? part_affected : nil
    end.compact
  end

  ##
  # Parts of the grid investment that are new to the user.
  #
  def unknown_parts_affected?
    parts_affected.any?{|part| !Current.setting.network_parts_affected.include?(part) }
  end

  def save_state_in_session
    Current.setting.network_parts_affected = parts_affected
  end
end
