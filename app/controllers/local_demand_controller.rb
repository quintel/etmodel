class LocalDemandController < TabController

  def intro
    Current.setting.already_shown?('local_demand', true)
  end
end
