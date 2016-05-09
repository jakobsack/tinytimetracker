class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user
  before_filter :authenticate
  before_filter :set_gettext_locale

  protected

  def authenticate
    # sessions controller and extern* are allowed to do everything
    unless logged_in?
      respond_to do |format|
        format.html { redirect_to new_session_path, error: _('Please login to continue!') }  # halts request cycle
        format.json { head :unauthorized }
      end
    end
  end

  def current_user_session
    return @current_user_session if defined? @current_user_session
    @current_user_session = Session.find
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.user
  end

  def logged_in?
    !!current_user
  end
end
