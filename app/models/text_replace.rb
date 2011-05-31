# TODO: are we using this?
class TextReplace

  def self.variables
    {
      '_ENDYEAR_' => Current.setting.end_year,
      '_YEARS_' => Current.setting.years
    }
  end

  def self.replace(txt)
    new_txt = txt
    variables.each do |key, replace_with|
      new_txt = new_txt.gsub(key, new_string)
    end
    new_txt
  end
end
