module SettingsHelper

  # Returns the radio button tag for a Constraint as used in the dashboard
  # changer template.
  #
  # @param [Constraint] constraint
  #   The constraint for which a radio button is wanted.
  #
  def constraint_radio_tag(constraint, checked = false)
    radio_button_tag "dash[#{ constraint.group }]", constraint.key, checked
  end

end
