module Expropriate
  extend ActiveSupport::Concern

  def expropriate
    resourceClass = params[:controller].singularize.capitalize.constantize

    if resource = resourceClass.find(params[:expropriator_id])
      clone = resource.full_clone
      clone.guide = @guide
      clone.save
      redirect_to(
        send("guide_#{params[:controller]}_path", @guide),
        notice: "Cloned #{clone.title}"
      )
    else
      redirect_to request.referer, notice: 'Failed to clone'
    end
  end
end
