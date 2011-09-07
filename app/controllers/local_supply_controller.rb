class LocalSupplyController < TabController

  def intro
    Current.setting.already_shown?('local_supply', true)
  end
end