module TableHelper
  def format_row_values(value)
    number, unit = format_value(value).split(' ')
    { number: number, unit: unit }
  end

  def formatted_data_rows(data)
    data.map do |row|
      present = format_row_values(row[:present])
      future = format_row_values(row[:future])
      {
        label: format_label(row[:serie]),
        present_value: present[:number],
        future_value: future[:number],
        unit: present[:unit],
        present_title: format_title(row[:present]),
        future_title: format_title(row[:future])
      }
    end
  end

  def formatted_totals(totals)
    return [] if totals.empty?

    present = format_row_values(totals[0])
    future = format_row_values(totals[1])
    {
      total_present_value: present[:number],
      total_future_value: future[:number],
      total_unit: present[:unit]
    }
  end
end
