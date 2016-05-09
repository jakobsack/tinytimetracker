# encoding: utf-8
class Session < Authlogic::Session::Base
  authenticate_with User

  generalize_credentials_error_messages _('Username and/or password invalid.')
  remember_me true
end
