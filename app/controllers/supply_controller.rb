class SupplyController < TabController
  def intro
    Current.setting.already_shown?('supply', true)
  end
end
