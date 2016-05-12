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

  describe '.invite' do
    let(:guide) { Fabricate :guide }

    context 'without a user' do
      let(:email) { 'bob@example.com' }

      it 'creates a user if they don not exist' do
        expect{ described_class.invite(email, guide) }.to change{ User.count }.by(1)
      end

      it 'gives user permission to access guide' do
        user = described_class.invite(email, guide)
        user.can_edit? guide
      end
    end

    context 'with user already existing' do
      let(:user) { Fabricate :user  }
      it 'reuses existing user' do
        expect(described_class.invite(user.email, guide)).to eq(user)
      end
      it 'gives user permission' do
        described_class.invite(user.email, guide)
        user.can_edit? guide
      end
    end
  end
end
