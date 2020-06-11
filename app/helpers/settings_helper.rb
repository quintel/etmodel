module SettingsHelper

  # Returns the radio button tag for a DashboardItem as used in the dashboard
  # changer template.
  #
  # @param [DashboardItem] dashboard_item
  #   The dashboard item for which a radio button is wanted.
  #
  def dashboard_item_radio_tag(dashboard_item, checked = false)
    radio_button_tag(
      "dash[#{dashboard_item.group}]",
      dashboard_item.key,
      checked
    )
  end
end
