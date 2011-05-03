class LocalDemandController < TabController

  def intro
    Current.already_shown?('local_demand', true)
  end
end
