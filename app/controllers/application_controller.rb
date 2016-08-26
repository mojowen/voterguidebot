class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  before_filter :authenticate_user!
  before_action :set_locale

  protect_from_forgery with: :exception

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  private

  def only_admin
    redirect_to root_path unless current_user.admin
  end
end
