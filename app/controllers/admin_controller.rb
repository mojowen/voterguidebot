class AdminController < ApplicationController
  before_filter :authenticate_admin!

  def promote
    user = User.find(params[:user])
    message = "promoted #{user.first_name}"
    redirect_to(
      admin_settings_path,
      notice: (user.promote!(current_user) ? "Successfully #{message}" : "FAIL #{message}"))
  end

  private

  def authenticate_admin!  
    return redirect_to root_url unless current_user.admin
  end
end
