class ContestsController < ApplicationController
  include GuideFinder
  include Reposition

  before_filter :init_contest, only: [:new, :create]
  before_filter :find_contest, except: [:new, :create, :index, :position]

  def create
    render json: update_contest
  end

  def update
    render json: update_contest
  end

  def destroy
    @contest.destroy
    render json: true
  end

  private

  def update_contest
    @contest.assign_attributes contest_params
    @contest.save
    {
      path: edit_guide_contest_path(@guide, @contest),
      contest: @contest.reload
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
    params.require(:contest).permit(
      :title, :description,
      questions: [:id, :text,
        answers: [:text, :candidate_id, :question_id],
        tags: [:name, :tagged_id, :tagged_type]],
      candidates: [:id, :name, :bio, :photo, :facebook,
                   :twitter, :website, :party,
        endorsements: [:endorser, :endorsed_id, :endorsed_type, :stance]])
  end
end
