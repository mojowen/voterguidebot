class UploadsController < ApplicationController

  def create
    @upload = Upload.create(upload_params)
    @upload.user = current_user

    if @upload.save
      render json: { path: @upload.file.url }, status: 200
    else
      render json: { error: @upload.errors.full_messages.join(',') }, status: 400
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:file)
  end

end
