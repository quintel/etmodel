module EtmAuthHelper
  def login_as(u)
    activate_authlogic
    UserSession.create(u)
  end
end
