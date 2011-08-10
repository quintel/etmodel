# TODO: Are we using this stuff?? PZ Wed 10 Aug 2011 11:48:57 CEST
##
# The +UserLogicHelper+ is a helper, which provides some basic user logic to 
# a user . 
#
# == Syntax
# 
# <filter conditions="country == nl">show this</filter>
# <filter conditions="country != nl">don't show this</filter>
#
# == Example
#
# if country is nl:
#
#   format_with_user_logic('<filter conditions="country == nl">show this</filter>')
#   => "show this" 
#
#   format_with_user_logic('<filter conditions="country != nl">don't show this</filter>')
#   => "" (empty string)
# 
# @responsible Jaap
#
#
module UserLogicHelper
  
  # The default parameters that can be used in the 
  # user logic block.
  def default_user_logic_environment
    {:country => (Current.setting && Current.setting.country) || "", :language => I18n.locale}
  end
  
  # Keys that are allowed in country.
  def default_allowed_keys
    [:country]
  end
  
  # Formats a string with a little bit of logic
  def format_with_user_logic(text, options = {})
    return nil if text.nil?
    options[:environment] ||= default_user_logic_environment
    options[:allowed_keys] ||= default_allowed_keys
  
    filters = find_filter_xml(text)
    evaluated_filters = filters.map { |x| evaluate_filter_xml(x, options)}
    filters.length.times do |i|
      text.gsub!(filters[i], evaluated_filters[i])
    end
    text
  end
  
  private
  
  # finds occurences of 
   # <filter></filter> in the text
   # Returns an array with the complete <filter blocks>
   def find_filter_xml(text)
     text.scan(/(<filter\b[^>]*>.*?<\/filter>)/i).map {|x| x.first}
   end

  
  
  # This method evaluates one filter tag
  def evaluate_filter_xml(text, options = {})
    matches = text.scan(/<filter conditions=["|'](.*)["|']>(.*)?<\/filter>/i).first
    conditions = matches[0]
    content = matches[1]
    
    if evaluate_conditions(conditions, options)
      return content
    else
      return ""
    end
  end  
  
  # Recursive method to evaluate a parse tree like 'and <condition> or <condition>'
  # This method stops if there are no and's or or's in the +def condition+
  def evaluate_conditions(condition, options = {})
    return evaluate_single_condition(condition, options) if condition.index("and").nil? && condition.index("or").nil?
    return condition.split("and").map {|x| evaluate_conditions(x.strip, options) }.all? if condition.index("and")
    return condition.split("or").map {|x| evaluate_conditions(x.strip, options) }.any? if condition.index("or")
  end
  
  # Evaluates only one single condition. Like country==en.
  #
  # At this moment the following operators are supported:
  #   
  #   !=
  #   ==
  #
  def evaluate_single_condition(condition, options = {})
    key, op, val = condition.scan(/(\w*)(\W*)(\w*)/).first
    equal_ops = ["==", "="]
    case op.strip
      when "=="
        return options[:environment][key.to_sym] == val
      when "="
        return options[:environment][key.to_sym] == val
      when "!="
        return options[:environment][key.to_sym] != val
    end
    return false
  end
  
 
end