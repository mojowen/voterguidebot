class ContestsController < ApplicationController
  include GuideFinder

  before_filter :init_contest, only: [:new, :create]
  before_filter :find_contest, except: [:new, :create, :index]

  def create
    return render json: update_contest
  end

  def update
    return render json: update_contest
  end

  private

  def update_contest
    @contest.assign_attributes contest_params
    @contest.save
    @contest.assign_associates associated_params
    {
      path: guide_contest_path(@guide, @contest),
      state: { contest: @contest.reload, url: guide_contest_path(@guide, @contest) }
    }
  end

  def init_contest
    @contest = @guide.contests.new
  end

  def find_contest
    @contest = @guide.contests
                     .includes({ questions: [:answers],
                                 candidates: [:endorsements] })
                     .find(params[:id])
  end

  def contest_params
    params.require(:contest).permit(:title, :description)
  end

  def associated_params
    params.require(:contest).permit(
      questions: [:id, :_destroy, :text,],
      candidates: [:id, :_destroy, :name, :bio, :photo, :facebook,
                   :twitter, :website ],
      answers: [:text, :candidate_id, :question_id],
      endorsements: [:endorser, :endorsing_id, :endorsing_type, :stance])
  end
end
