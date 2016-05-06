class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery with: :exception
end
