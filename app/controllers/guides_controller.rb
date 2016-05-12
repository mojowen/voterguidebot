class GuidesController < ApplicationController
  before_filter :find_guide, except: [:create, :new, :index]
  before_filter :init_guide, only: [:create, :new]
  before_filter :guide_params, only: [:create, :update]
  before_filter :invite_params, only: :users

  def create
    @guide = Guide.new guide_params
    @guide.users << current_user

    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :new
    end
  end

  def index
    redirect_to root_path
  end

  def users
    user = User.invite(invite_params, @guide)
    render json: { state: user.valid? ? 'success' : 'error' }
  end

  private

  def guide_params
    params.require(:guide).permit(:name)
  end

  def invite_params
    params.require(:email)
  end

  def init_guide
    @guide = Guide.new
  end

  def find_guide
    @guide = Guide.find params[:id]
    return redirect_to guides_path unless current_user.can_edit?(@guide)
  end
end
