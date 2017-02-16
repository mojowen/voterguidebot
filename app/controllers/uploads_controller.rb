class UploadsController < ApplicationController
  include GuideFinder

  def create
    upload = @guide.uploads.new(upload_params)
    upload.user = current_user

    if upload.save
      render json: { path: upload.file.url }, status: 200
    else
      render json: { error: upload.errors[:file].join(',') }, status: 400
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:file)
  end
end
