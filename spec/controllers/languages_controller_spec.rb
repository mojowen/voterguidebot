require 'rails_helper'

RSpec.describe LanguagesController, active_mocker: true do
  let(:user) { Fabricate :user }
  let(:guide) { Fabricate :guide, users: [user] }
  before(:each) { sign_in user }

  describe '#index' do
    it 'gets the languages' do
      get :index, { guide_id: guide.id }
      expect(response).to be_success
    end
  end

  describe '#create' do
    it 'creates a language' do
      expect do
        post :create, { guide_id: guide.id, language: { code: :es } }
      end.to change(Language, :count).by(1)
    end
  end

  describe '#destroy' do
    let!(:language) { Fabricate :language, guide: guide }
    it 'destroys a language' do
      expect do
        delete :destroy, { guide_id: guide.id, id: language.id }
      end.to change(Language, :count).by(-1)
    end
  end
end
