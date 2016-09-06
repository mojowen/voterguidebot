require 'rails_helper'

RSpec.describe MeasuresController, active_mocker: true do
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
    let(:against_endorsements) do
      {
        endorser: "someone against",
        endorsed_type: "measure",
        endorsed_id: false,
        stance: "against"
      }
    end
    let(:for_endorsements) do
      {
        endorser: "someone for",
        endorsed_type: "measure",
        endorsed_id: false,
        stance: "for"
      }
    end
    let(:tag) do
      {
        name: 'LGBTQ',
        tagged_id: '5',
        tagged_type: 'measure'
      }
    end
    let(:measure_params) do
      { guide_id: guide.id,
        measure: {
          title: 'Sweet',
          description: 'Baller',
          stance: 'for',
          yes_means: 'Straight creeping',
          no_means: 'No creapin',
          endorsements: [for_endorsements, against_endorsements],
          tags: [tag]
        }}
    end
    it 'creates measure' do
      expect do
        post :create, measure_params
      end.to change(Measure, :count).by(1)
    end
    it 'assigns title' do
      post :create, measure_params
      expect(assigns(:measure).title).to eq('Sweet')
    end
    it 'assigns description' do
      post :create, measure_params
      expect(assigns(:measure).description).to eq('Baller')
    end
    it 'assigns stance' do
      post :create, measure_params
      expect(assigns(:measure).stance).to eq('for')
    end
    it 'assigns yes_mans' do
      post :create, measure_params
      expect(assigns(:measure).yes_means).to eq('Straight creeping')
    end
    it 'assigns no_means' do
      post :create, measure_params
      expect(assigns(:measure).no_means).to eq('No creapin')
    end
    it 'assigns endorsements' do
      post :create, measure_params
      expect(assigns(:measure).endorsements.map(&:endorser)).to include(against_endorsements[:endorser])
      expect(assigns(:measure).endorsements.map(&:endorser)).to include(for_endorsements[:endorser])
    end
    it 'assigns tags' do
      post :create, measure_params
      expect(assigns(:measure).tags.map(&:name)).to include(tag[:name])
    end
  end

  context 'with a measure' do
    let!(:measure) { Fabricate :measure, guide: guide }
    describe '#edit' do
      render_views
      it 'renders successfully' do
        get :edit, { guide_id: guide.id, id: measure.id }
        expect(response).to be_success
      end
    end
    describe '#update' do
      let(:measure_params) do
        { guide_id: guide.id, id: measure.id, measure: { title: 'Test' } }
      end
      it 'is successful' do
        put :update, measure_params
        expect(response).to be_success
      end

      it 'assigns associations' do
        put :update, measure_params
        expect(measure.reload.title).to eq('Test')
      end

      context 'with empty associations' do
        let!(:endorsement) { Fabricate :endorsement, endorsed: measure }
        let!(:tag) { Fabricate :tag, tagged: measure }
        let(:measure_params) do
          { guide_id: guide.id, id: measure.id, measure: { title: measure.title } }
        end

        it 'removes empty association' do
          put :update, measure_params
          expect(measure.reload.endorsements.empty?).to be true
          expect(measure.reload.tags.empty?).to be true
        end
      end
    end
    describe '#destroy' do
      it 'redirects to index' do
        delete :destroy, { guide_id: guide.id, id: measure.id }
        be_success
      end

      it 'destroys measures' do
        expect do
          delete :destroy, { guide_id: guide.id, id: measure.id }
        end.to change(Measure, :count).by(-1)
      end
    end
    context 'with another measure' do
      let!(:other_measure) { Fabricate :measure, guide: guide }

      describe '#position' do
        it 'is successful' do
          put :position, { guide_id: guide.id, measures: [other_measure.id, measure.id] }
          be_success
        end
        it 'changes the position on the resource' do
          put :position, { guide_id: guide.id, measures: [other_measure.id, measure.id] }
          expect(other_measure.reload.position).to eq(0)
          expect(measure.reload.position).to eq(1)
        end
      end
    end

    context 'with another guide' do
      let!(:user) { Fabricate :user }
      let!(:user_guide) { Fabricate :guide, users: [user] }
      let!(:endorsement) { Fabricate :endorsement, endorsed: measure }
      let!(:tag) { Fabricate :tag, tagged: measure }

      before(:each) { sign_in user }

      describe '#expropriate' do
        it 'clones a measure to a different guide' do
          post :expropriate, { guide_id: user_guide.id, expropriator_id: measure.id }
          cloned = user_guide.measures.first
          expect(cloned.title).to eq(measure.title)

          expect(cloned.endorsements.first.endorser).to eq(measure.endorsements.first.endorser)
          expect(cloned.tags.first.name).to eq(measure.tags.first.name)
        end

        it 'redirects to all measures for cloned to guide' do
          post :expropriate, { guide_id: user_guide.id, expropriator_id: measure.id }
          expect(response).to redirect_to guide_measures_path(user_guide, locale: :en)
        end
      end
    end
  end
end
