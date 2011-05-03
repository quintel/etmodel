# https://github.com/binarylogic/authlogic/issues/closed#issue/201
class UserSession < Authlogic::Session::Base

  allow_http_basic_auth false
  
end
