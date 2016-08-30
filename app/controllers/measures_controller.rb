class MeasuresController < ApplicationController
  include GuideFinder
  include Reposition
  include Expropriate

  before_filter :init_measure, only: [:new, :create]
  before_filter :find_measure, only: [:edit, :update, :destroy]

  def index
    redirect_to new_guide_measure_path(@guide) if @guide.measures.empty?
  end

  def create
    render json: update_measure
  end

  def update
    render json: update_measure
  end

  def destroy
    @measure.destroy
    render json: true
  end

  private

  def update_measure
    @measure.assign_attributes measure_param
    if @measure.save
      {
        path: edit_guide_measure_path(@guide, @measure),
        url: guide_measure_path(@guide, @measure),
        measure: @measure.reload
      }
    else
      {
        error: @measure.errors.full_messages.join(','),
        measure: @measure
      }
    end
  end

  def init_measure
    @measure = @guide.measures.new
  end

  def find_measure
    @measure = @guide.measures.find(params[:id])
  end

  def measure_param
    params.require(:measure).permit(:title, :description, :stance, :yes_means, :no_means,
                                    endorsements: [:endorser, :endorsed_id,
                                                   :endorsed_type, :stance],
                                    tags: [:name, :tagged_id, :tagged_type])
  end
end
