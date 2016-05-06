require 'rails_helper'

RSpec.describe User, active_mocker: true do

  describe '.from_omniauth' do
    let(:email) { 'john@arizona.org' }
    let(:user_data) {
      { 'first_name': 'John',
        'last_name': 'McCain',
        'image': 'http://some-image',
        'email': email }.with_indifferent_access
    }
    let(:google_auth) { instance_double(OmniAuth::Strategies::GoogleOauth2, info: user_data) }
    context 'for a user that already exists' do
      let!(:user) { Fabricate :user, email: email }
      it 'signs a user in based on their email' do
        expect(described_class.from_omniauth(google_auth).id).to eq user.id
      end
    end
    it 'creates a new user if they cannot be found' do
      expect{ described_class.from_omniauth(google_auth) }.to change{ User.count }.by(1)
    end
  end

  describe '#can_edit' do
    let(:guide) { Fabricate :guide }
    context 'when user has permission' do
      it 'returns true' do
        allow(subject).to receive(:guides).and_return([guide])
        expect(subject.can_edit?(guide)).to be_truthy
      end
    end
    context 'when user does not have permission' do
      it 'returns false' do
        expect(subject.can_edit?(guide)).to be_falsey
      end
    end
    context 'when user is admin' do
      before(:each) { subject.update_attributes admin: true }
      it 'returns true' do
        expect(subject.can_edit?(guide)).to be_truthy
      end
    end
  end
end
