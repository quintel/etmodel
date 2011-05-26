class LocalSupplyController < TabController

  def intro
    Current.already_shown?('local_supply', true)
  end
end