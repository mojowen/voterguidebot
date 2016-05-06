require 'rails_helper'

RSpec.describe HomeController, active_mocker: true do

  describe '#welcome' do
    render_views
    it 'returns successfully' do
      get :welcome
      expect(response).to be_success
    end
  end

  describe '#index' do
    context 'is logged in' do
      render_views
      before(:each) { sign_in Fabricate :user }
      it 'returns successfully' do
        get :index
        expect(response).to be_success
      end
    end
    context 'not logged in' do
      it 'returns successfully' do
        get :index
        expect(response).to be_redirect
      end
    end
  end
end
