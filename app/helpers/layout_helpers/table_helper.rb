module LayoutHelpers::TableHelper
  def table(column_names)
    html_tag :table do
      html_tag :thead do
        column_names.each do |column_name|
          html_tag :th, column_name
        end
      end
      html_tag :tbody do
      end
    end
  end
end