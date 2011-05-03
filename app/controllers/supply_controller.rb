class SupplyController < TabController
  def intro
    Current.already_shown?('supply', true)
  end
end
