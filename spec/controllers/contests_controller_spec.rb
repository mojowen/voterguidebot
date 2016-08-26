require 'rails_helper'

RSpec.describe ContestsController, active_mocker: true do
  let(:user) { Fabricate :user }
  let(:guide) { Fabricate :guide, users: [user] }
  before(:each) { sign_in user }

  describe '#new' do
    render_views
    it 'renders successfully' do
      get :new, { guide_id: guide.id }
      expect(response).to be_success
    end
  end

  describe '#create' do
    let(:contest_params) do
      { guide_id: guide.id, contest: { title: 'Sweet', description: 'Baller'}}
    end
    it 'creates contests' do
      expect do
        post :create, contest_params
      end.to change(Contest, :count).by(1)
    end
    it 'assigns title' do
      post :create, contest_params
      expect(assigns(:contest).title).to eq('Sweet')
    end
    it 'assigns description' do
      post :create, contest_params
      expect(assigns(:contest).description).to eq('Baller')
    end
    context 'with assciations' do
      let(:candidates) do
        [{ 'id' => '1',
           'name' => 'Frank',
           'bio' => 'Frank is an ass',
           'photo' => '/pretty-picture',
           'facebook' => 'http://facebook.com/frank',
           'twitter' => 'http://twitter.com/frank',
           'website' => 'http://franksplace.com',
           'party' => 'Democrat',
           'endorsements' => endorsements }]
      end
      let(:questions) do
        [{ 'id' => '1',
           'text' => 'WHAT ARE THOSE',
           'answers' => answers,
           'tags' => tags }]
      end
      let(:answers) do
        [{ 'text' => 'Yes',
           'candidate_id' => '5',
           'question_id' => '5' }]
      end
      let(:tags) do
        [{ 'name' => 'LGBTQ',
           'tagged_id' => '5',
           'tagged_type' => 'question' }]
      end
      let(:endorsements) do
        [{ 'endorser' => 'Ben and Jerrys',
           'endorsed_id' => '5',
           'endorsed_type' => 'candidate',
           'stance' => 'for' }]
      end
      let(:contest_params) do
        { guide_id: guide.id,
          contest: {
            title: 'Sweet',
            description: 'Baller',
            candidates: candidates,
            questions: questions,
          }}
      end
      it 'is successful' do
        expect(subject).to receive(:update_contest)
        post :create, contest_params
        expect(response).to be_success
      end
      it 'assigns associations' do
        contest = instance_double(Contest, assign_attributes: true, save: true,
                                  reload: true)
        expect(contest).to receive(:assign_attributes).with(contest_params[:contest])
        allow(subject).to receive(:init_contest) do
          subject.instance_variable_set(:@contest, contest)
        end
        post :create, contest_params
      end
    end
  end

  context 'with a contest' do
    let!(:contest) { Fabricate :contest, guide: guide }
    describe '#edit' do
      render_views
      it 'renders successfully' do
        get :edit, { guide_id: guide.id, id: contest.id }
        expect(response).to be_success
      end
    end
    describe '#update' do
      let(:contest_params) do
        { guide_id: guide.id, id: contest.id, contest: { title: 'Test' } }
      end
      it 'is successful' do
        put :update, contest_params
        expect(response).to be_success
      end

      it 'assigns associations' do
        expect(subject).to receive(:update_contest)
        put :update, contest_params
      end
    end
    describe '#destroy' do
      it 'returns successful' do
        delete :destroy, { guide_id: guide.id, id: contest.id }
        be_success
      end

      it 'destroys contest' do
        expect do
          delete :destroy, { guide_id: guide.id, id: contest.id }
        end.to change(Contest, :count).by(-1)
      end
    end

    describe '#index' do
      render_views
      it 'returns successfully' do
        get :index, { guide_id: guide.id }
        be_success
      end
    end

    context 'with another contest' do
      let!(:other_contest) { Fabricate :contest, guide: guide }

      describe '#position' do
        it 'is successful' do
          put :position, { guide_id: guide.id, contests: [other_contest.id, contest.id] }
          be_success
        end
        it 'changes the position on the resource' do
          put :position, { guide_id: guide.id, contests: [other_contest.id, contest.id] }
          expect(other_contest.reload.position).to eq(0)
          expect(contest.reload.position).to eq(1)
        end
      end
    end

    context 'with another guide' do
      let!(:user) { Fabricate :user }
      let!(:user_guide) { Fabricate :guide }
      let!(:candidate) { Fabricate :candidate, contest: contest }
      let!(:question) { Fabricate :question, contest: contest }
      let!(:answer) { Fabricate :answer, candidate: candidate, question: question }

      before(:each) { sign_in user }

      describe '#expropriate' do
        it 'clones a contest to a different guide' do
          post :expropriate, { guide_id: user_guide.id, expropriator_id: contest.id }
          cloned = user_guide.contests.first
          expect(cloned.title).to eq(contest.title)

          expect(cloned.candidates.first.name).to eq(candidate.name)
          expect(cloned.questions.first.text).to eq(contest.questions.first.text)
          expect(cloned.answers.first.text).to eq(contest.answers.first.text)
        end

        it 'redirects to all contests for cloned to guide' do
          post :expropriate, { guide_id: user_guide.id, expropriator_id: contest.id }
          expect(response).to redirect_to guide_contests_path(user_guide, locale: :en)
        end
      end
    end
  end
end
