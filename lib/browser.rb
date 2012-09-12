module Browser
  ALLOWED_BROWSERS = %w[firefox ie10 ie9 ie8 ie7 chrome safari]

  def user_agent
    user_agent = request.env['HTTP_USER_AGENT']
    return 'firefox' if user_agent =~ /Firefox/
    return 'chrome' if user_agent =~ /Chrome/
    return 'safari' if user_agent =~ /Safari/
    return 'opera' if user_agent =~ /Opera/
    return 'ie9' if user_agent =~ /MSIE 9/
    return 'ie8' if user_agent =~ /MSIE 8/
    return 'ie7' if user_agent =~ /MSIE 7/
    return 'ie6' if user_agent =~ /MSIE 6/
  end

  def supported_browser?
    ALLOWED_BROWSERS.include?(user_agent)
  end
end