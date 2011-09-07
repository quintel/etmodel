class PolicyController < TabController
  def intro
    Current.setting.already_shown?('policy', true)
  end
end
