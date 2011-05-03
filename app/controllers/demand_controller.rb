class DemandController < TabController
  def intro
    Current.already_shown?('demand', true)
  end
end
