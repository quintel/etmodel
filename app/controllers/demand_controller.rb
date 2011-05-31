class DemandController < TabController
  def intro
    Current.already_shown?('demand', true)
    
    bars  = ['Households']
    bars += ['Buildings'] if Current.setting.area
    bars += ['Transport', 'Industry', 'Agriculture', 'Other']
    
    queries = ['present:SUM(V(G(final_demand_cbs);final_demand))']
    queries += bars.map{|x| "present:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(#{x.downcase}));final_demand))"}
    
    gql = Api::Query.new
    gql.queries = queries
    gql.fresh_session_id # DEBT: recycle existing session
    
    @total = gql.fetch_single_value('present:SUM(V(G(final_demand_cbs);final_demand))').to_f
    
    @items = {}
    
    bars.each do |b|
      key = b.downcase
      val = gql.fetch_single_value("present:SUM(V(INTERSECTION(G(final_demand_cbs),SECTOR(#{key}));final_demand))")
      @items[key] ||= {
        :name      => b,
        :value     => val,
        :percent   => val / @total * 100,
        :clickable => Current.view.sidebar_items.map(&:key).include?(key),
        :active    => params[:action] = key # can this ever happen?
      }
    end
    
  end
end
