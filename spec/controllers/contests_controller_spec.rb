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
           '_destroy' => true,
           'name' => 'Frank',
           'bio' => 'Frank is an ass',
           'photo' => '/pretty-picture',
           'facebook' => 'http://facebook.com/frank',
           'twitter' => 'http://twitter.com/frank',
           'website' => 'http://franksplace.com',
           'endorsements' => endorsements }]
      end
      let(:questions) do
        [{ 'id' => '1',
           '_destroy' => true,
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
           'question_id' => '5' }]
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
    let(:contest) { Fabricate :contest, guide: guide }
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
  end

end
