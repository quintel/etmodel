##
# Helpers that are used in the backend area, and not used for the user area
#
module BackendHelper
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
