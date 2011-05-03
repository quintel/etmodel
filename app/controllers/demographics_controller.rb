class DemographicsController < TabController

  def intro
    Current.already_shown?('demographics', true)
  end
end
