module Browser
  ALLOWED_BROWSERS = %w[firefox ie11 ie10 ie9 ie8 ie7 chrome safari]

  def user_agent
    case request.env['HTTP_USER_AGENT']
    when /Firefox/    then 'firefox'
    when /Chrome/     then 'chrome'
    when /Safari/     then 'safari'
    when /Opera/      then 'opera'
    when /Trident\/7/ then 'ie11'
    when /MSIE 10/    then 'ie10'
    when /MSIE 9/     then 'ie9'
    when /MSIE 8/     then 'ie8'
    when /MSIE 7/     then 'ie7'
    when /MSIE 6/     then 'ie6'
    end
  end

  def supported_browser?
    ALLOWED_BROWSERS.include?(user_agent)
  end
end
