require 'rails_helper'

RSpec.describe ExportsController, type: :controller do
  let(:guide) { Fabricate :guide, users: [user] }
  let(:user) { Fabricate :user }
  before(:each) { sign_in user }

  describe '#new' do
    render_views

    it 'renders sucessfully' do
      get :new
      expect(response).to be_success
    end
  end

  describe '#create' do
    let(:params) { { export: { guides: { guide.id => '1' } } } }

    it 'creates a new export' do
      expect do
        post :create, params
      end.to change(Export, :count).by(1)
    end

    it 'schedules a delayed job' do
      post :create, params
      expect do
        post :create, params
      end.to change(Delayed::Job, :count).by(1)
    end
  end

  context 'with export' do
    let!(:export) { Fabricate :export, guides: [guide], user: user }

    describe '#index' do
      render_views

      it 'renders sucessfully' do
        get :index
        expect(response).to be_success
      end
    end

    describe '#update' do
      render_views
      let(:params) { { id: export.id } }

      it 'schedules a delayed job' do
        expect do
          post :update, params
        end.to change(Delayed::Job, :count).by(1)
      end
    end
  end
end
