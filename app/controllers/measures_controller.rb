class MeasuresController < ApplicationController
  include GuideFinder

  before_filter :init_measure, only: [:new, :create]
  before_filter :find_measure, except: [:new, :create, :index]

  def create
    return render json: update_measure
  end

  def update
    return render json: update_measure
  end

  private

  def update_measure
    @measure.assign_attributes measure_param
    @measure.save
    {
      path: guide_contest_path(@guide, @measure),
      state: { measure: @measure.reload, url: edit_guide_measure_path(@guide, @measure) }
    }
  end

  def init_measure
    @measure = @guide.measures.new
  end

  def find_measure
    @measure = @guide.measures.find(params[:id])
  end

  def measure_param
    params.require(:measure).permit(:title, :description, :yes_means, :no_means,
                                    endorsements: [:endorser, :endorsed_id,
                                                   :endorsed_type, :stance],
                                    tags: [:name, :tagged_id, :tagged_type])
  end
end
