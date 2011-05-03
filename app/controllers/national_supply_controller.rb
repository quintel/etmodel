class NationalSupplyController < TabController

  def intro
    Current.already_shown?('national_supply', true)
  end
end
