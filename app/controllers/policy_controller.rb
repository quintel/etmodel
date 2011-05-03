class PolicyController < TabController
  def intro
    Current.already_shown?('policy', true)
  end
end
