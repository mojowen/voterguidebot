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
    @measure.assign_attributes guide_params
    @measure.save
    {
      path: guide_contest_path(@guide, @measure),
      state: { measure: @measure.reload, url: guide_contest_path(@guide, @measure) }
    }
  end

  def init_measure
    @measure = @guide.measures.new
  end

  def find_measure
    @measure = @guide.measures.find(params[:id])
  end

  def guide_params
    params.require(:measure).permit(:title, :description, :yes_means, :no_means,
                                    endorsements: [:endorser, :endorsing_id])
  end
end
