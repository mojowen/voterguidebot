class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  before_filter :authenticate_user!
  before_action :set_locale
  force_ssl if: :ssl_configured?

  protect_from_forgery with: :exception

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def ssl_configured?
    Rails.env.production?
  end

  def only_admin
    redirect_to root_path unless current_user.admin
  end
end
