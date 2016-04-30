# encoding: utf-8
class Session < Authlogic::Session::Base
  authenticate_with User

  generalize_credentials_error_messages 'Benutzername und/oder Passwort ungültig'
  remember_me true
end
