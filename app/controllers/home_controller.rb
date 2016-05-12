class HomeController < ApplicationController
  before_filter :authenticate_user!, except: :welcome
end
