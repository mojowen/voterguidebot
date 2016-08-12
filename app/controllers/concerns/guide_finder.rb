module GuideFinder
  extend ActiveSupport::Concern

  included do
    before_filter :find_guide
    before_filter :check_space, only: :new
  end

  def find_guide
    @guide = Guide.find params[:guide_id]
    redirect_to guides_path unless current_user.can_edit?(@guide)
  end

  def check_space
    redirect_to url_for(action: :index), notice: "No space for another #{params[:controller].singularize}" unless @guide.is_there_space?(**{ params[:controller].to_sym => 1})
  end
end
