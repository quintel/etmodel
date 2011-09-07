class DemographicsController < TabController

  def intro
    Current.setting.already_shown?('demographics', true)
  end
end
