##
# Helpers that are used in the backend area, and not used for the user area
#
module BackendHelper

  def descriptions_for_class(klass, objects = nil, &block)
    objects ||= klass.includes(:description)
    haml_tag :hr
    haml_tag :a, "top", :href=>"#top"
    haml_tag :hr
    haml_tag :h1, klass.name, :id => klass.name
    haml_tag :table,table_defaults do
      objects.each do |describable|
        haml_tag :tr, :class => cycles[:class].strip do
          haml_tag :td, describable.id
          yield(describable)
          haml_tag :td, new_or_edit_description(describable)
        end
      end
    end
  end

  def new_or_edit_description(describable)
    if desc = describable.description
      link_to("edit", edit_data_description_path(:id=> desc.id))
    else
      link_to("create", new_data_description_path(
        :describable_id => describable.id,
        :describable_type => describable.class.name
      ))
    end
  end


  def print_array_tree(array_of_arrays)
    haml_tag :ul do
      array_of_arrays.each do |el|
        if el.is_a?(Array)
          haml_tag :li do
            str = el.first.to_s
            str += ": "+@converter.query(el.first).to_s if @converter and @converter.query.respond_to?(el.first)
            haml_concat str
            print_array_tree(el[1..-1])
          end
        else
          haml_tag :li, el.to_s
        end
      end
    end
  end

  ##
  # Return the source code of the method.
  # The end line of the method has an end with the same intendation as the method header.
  #
  def method_source(method)
    file, line = method.source_location
    lines = File.read(file).lines.to_a[line-1..-1]

    method_header = lines.first
    intendation = method_header[/^(.*)def/, 1]
    line_of_end_statement = lines.index{|l| l.start_with?("#{intendation}end")}

    lines = lines[0..line_of_end_statement]
    lines.join("")
  end
end
