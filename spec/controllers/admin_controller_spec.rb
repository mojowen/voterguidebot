require 'rails_helper'

RSpec.describe AdminController, active_mocker: true do

  describe '#settings' do
    context 'is logged in as regular user' do
      render_views
      before(:each) { sign_in Fabricate :user, admin: true }
      it 'returns successfully' do
        get :settings
        expect(response).to be_success
      end
    end
    context 'not logged in' do
      before(:each) { sign_in Fabricate :user }
      it 'returns successfully' do
        get :settings
        expect(response).to be_redirect
      end
    end
  end

  describe '#promote' do
    let(:admin) { Fabricate :user, admin: true }
    let(:user) { instance_double(User, first_name: 'what') }
    before(:each) do
      sign_in admin
      allow(User).to receive(:find).and_return(user)
    end

    it 'it promotes a user successfully' do
      expect(user).to receive(:promote!).with(admin).and_return(nil)
      post :promote, { user: 5 }
      expect(response).to be_redirect
    end
    it 'it promotes a user unsuccessfully' do
      expect(user).to receive(:promote!).with(admin).and_return(nil)
      post :promote, { user: 5 }
      expect(response).to be_redirect
    end
  end

end
