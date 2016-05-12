class HomeController < ApplicationController
  before_filter :authenticate_user!, except: :welcome

  def add
  end
end
