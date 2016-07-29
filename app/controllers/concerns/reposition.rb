module Reposition
  extend ActiveSupport::Concern

  def position
    ids = params[params[:controller].pluralize]
    @guide.send(params[:controller]).each do |resource|
      resource.update_attributes position: ids.index{ |id| id.to_i == resource.id }
    end
    render json: true
  end
end
