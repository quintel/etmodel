class CostsController < TabController
  def intro
    Current.setting.already_shown?('costs', true)
  end
end
