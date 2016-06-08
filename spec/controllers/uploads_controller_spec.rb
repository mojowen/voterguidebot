require 'rails_helper'

RSpec.describe UploadsController, active_mocker: true do
  let(:user) { Fabricate :user }
  before(:each) { sign_in user }

  describe '#create' do
    let(:upload_params) do
      {
        upload: {
          file: fixture_file_upload('test.png', 'image/png')
        }
      }
    end
    it 'creates a new upload' do
      expect do
        post :create, upload_params
      end.to change(Upload, :count).by(1)
    end
    it 'associates new upload with current user' do
      post :create, upload_params
      expect(assigns(:upload).user).to eq(user)
    end
    it 'returns success' do
      post :create, upload_params
      expect(response).to be_success
    end
  end
end
