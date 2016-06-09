module GuideFinder
  extend ActiveSupport::Concern

  included { before_filter :find_guide }

  def find_guide
    @guide = Guide.find params[:guide_id]
    redirect_to guides_path unless current_user.can_edit?(@guide)
  end
end
