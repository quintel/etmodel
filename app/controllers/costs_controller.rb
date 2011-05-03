class CostsController < TabController
  def intro
    Current.already_shown?('costs', true)
  end
end
