class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
    sign_in_and_redirect @user, event: :authentication
  end

end
