module AdminHelper
  def color_options(selected)
    base = Colors::COLORS.values.include?(selected) ? [] : ([[selected] * 2])
    Colors::COLORS.to_a + base
  end
end
