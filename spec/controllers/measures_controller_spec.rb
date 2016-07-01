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
          yes_means: 'Straight creeping',
          no_means: 'No creapin',
          endorsements: [for_endorsements, against_endorsements],
          tags: [tag]
        }}
    end
    it 'creates contests' do
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
    let(:measure) { Fabricate :measure, guide: guide }
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
    end
  end

end
