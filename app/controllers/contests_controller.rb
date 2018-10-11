class ContestsController < ApplicationController
  include GuideFinder
  include Reposition
  include Expropriate

  before_filter :init_contest, only: [:new, :create]
  before_filter :find_contest, only: [:edit, :update, :destroy]

  def index
    redirect_to new_guide_contest_path(@guide) if @guide.contests.empty?
  end

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
    if @contest.save
      {
        path: edit_guide_contest_path(@guide, @contest),
        url: guide_contest_path(@guide, @contest),
        contest: @contest.reload
      }
    else
      {
        error: @contest.errors.full_messages.join(','),
        contest: @contest.full_json
      }
    end
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
    attrs = params.require(:contest).permit(
      :title, :description,
      questions: [:id, :text,
        answers: [:text, :candidate_id, :question_id],
        tags: [:name, :tagged_id, :tagged_type]],
      candidates: [:id, :name, :bio, :photo, :facebook,
                   :twitter, :website, :party,
        endorsements: [:endorser, :endorsed_id, :endorsed_type, :stance]])

    attrs[:candidates] ||= []
    attrs[:candidates].map! do |candidate|
      candidate[:endorsements] ||= []
      candidate[:endorsements] ||= []
      candidate
    end

    attrs[:questions] ||= []
    attrs[:questions].map! do |questin|
      questin[:answers] ||= []
      questin[:tags] ||= []
      questin
    end

    attrs
  end
end
