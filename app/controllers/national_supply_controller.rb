class NationalSupplyController < TabController

  def intro
    Current.setting.already_shown?('national_supply', true)
  end
end
