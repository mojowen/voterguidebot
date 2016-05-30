class ContestsController < ApplicationController
  before_filter :find_guide

  def create
  end

  def update
  end

  private

  def find_guide
    @guide = Guide.find params[:guide_id]
    return redirect_to guides_path unless current_user.can_edit?(@guide)
  end
end
