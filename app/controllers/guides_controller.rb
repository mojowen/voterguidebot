class GuidesController < ApplicationController
  before_filter :find_guide, except: [:create, :new, :index]
  before_filter :init_guide, only: [:create, :new]
  before_filter :guide_params, only: [:create, :update]
  before_filter :invite_params, only: :users

  def create
    if cloned_guide
      @guide.update_attributes guide_params
    else
      @guide = Guide.new(guide_params)
      @guide.users << current_user
    end

    if @guide.save
      redirect_to guide_path @guide
    else
      render :new
    end
  end

  def index
    redirect_to root_path unless current_user.admin
  end

  def update
    @guide.update_attributes guide_params
    @guide.template_fields = field_params if field_params

    respond_to do |format|
      format.html do
        return redirect_to guide_path(@guide), notice: 'Guide saved!' if @guide.save
        render :edit
      end
      format.json do
        render json: '', status: @guide.save ? 200 : 400
      end
    end
  end

  def users
    user = User.invite(invite_params, @guide, current_user.first_name)
    render json: { state: user.valid? ? 'success' : 'error' }
  end

  def preview
    render **@guide.template.render.update( locals: { guide: @guide, preview: true } )
  end

  def publish
    @guide.start_publishing
    redirect_to request.referer || guide_path(@guide), notice: 'Guide queued for publishing'
  end

  private

  def cloned_guide
    return unless params[:cloned_id]
    clone_source = Guide.find(params[:cloned_id])
    return unless clone_source && current_user.can_edit?(clone_source)
    @guide = clone_source.full_clone
  end

  def field_params
    params.require(:guide).permit(fields: @guide.template_field_names)[:fields]
  end

  def guide_params
    params.require(:guide).permit(
        :name,
        :election_date,
        location_attributes: [:city, :state, :address, :lat, :lng,
                              :north, :south, :east, :west])
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
