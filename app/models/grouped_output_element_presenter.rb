# frozen_string_literal: true

# Given output elements already grouped (by OutputElement.select_by_group), creates a JSON
# representation of the hierarchy of the elements, and minimal information about each.
class GroupedOutputElementPresenter
  def initialize(grouped_elements)
    @grouped_elements = grouped_elements
    @view_context = ActionController::Base.new.view_context
  end

  def as_json(*)
    @grouped_elements.map do |key, value|
      group_name = I18n.t("chart_group.#{key.downcase}")

      # Grouped charts come in two forms: either an array - in which case this is a top-level group
      # with charts belonging to it without any subgroups - or an Hash of subgroup keys and the
      # charts belonging to them.
      if value.is_a?(Array)
        group_as_json(key, value).merge(type: :group, name: group_name)
      elsif value.is_a?(Hash)
        {
          elements: subgroups_as_json(value),
          key: key&.downcase&.presence,
          name: group_name,
          type: :group
        }
      end
    end
  end

  private

  # Internal: Creates the JSON representation of a group (or subgroup) for which all the elements
  # are output elements.
  def group_as_json(name, elements)
    {
      elements: elements
        .map { |element| output_element_as_json(element) }
        .sort_by { |el| el[:name] },
      key: name&.downcase&.presence
    }
  end

  # Internal: Receives an array of subgroups and creates the JSON for each group and its output
  # elements
  def subgroups_as_json(groups)
    groups.map do |name, elements|
      group_as_json(name, elements).merge(
        name: name && I18n.t("chart_sub_group.#{name.downcase}"),
        type: :subgroup
      )
    end
  end

  # Internal: Creates the JSON representation of a single output element.
  def output_element_as_json(element)
    element.as_json(
      only: %w[key output_element_type_name]
    ).merge(
      name: I18n.t("output_elements.#{element.key}.title"),
      image_url: @view_context.image_url("output_elements/#{element.icon}")
    )
  end
end
