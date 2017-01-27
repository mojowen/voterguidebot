require 'rails_helper'

RSpec.describe User, active_mocker: true do

  # Instance Methods

  describe '#can_edit' do
    let(:guide) { Fabricate :guide }
    context 'when user has permission' do
      it 'returns true' do
        allow(subject).to receive(:guides).and_return([guide])
        expect(subject.can_edit?(guide)).to be_truthy
      end
    end
    context 'when guide is inactive' do
      it 'returns false' do
        guide.update_attributes active: false
        expect(subject.can_edit?(guide)).to be_falsey
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

  describe '#promote' do
    subject { Fabricate :user }

    context 'with an admin' do
      let(:admin) { Fabricate :user, admin: true }
      it 'promotes the user' do
        subject.promote! admin
        expect(subject.admin).to be_truthy
      end
      it 'sends a notice' do
        expect(UserMailer).to receive(:promote)
                              .with(subject, admin)
                              .and_return(double(deliver_later: true))
        subject.promote! admin
      end
    end

    context 'without an admin' do
      let(:admin) { Fabricate :user }
      it 'promotes the user' do
        subject.promote! admin
        expect(subject.admin).to be_falsey
      end
      it 'does not send a notice' do
        expect(UserMailer).to_not receive(:promote)
        subject.promote! admin
      end
    end
  end

  # Class Methods

  describe '.invite' do
    let(:guide) { Fabricate :guide }

    context 'without a user' do
      let(:email) { 'bob@example.com' }

      it 'creates a user if they don not exist' do
        expect{ described_class.invite(email, guide, 'Jimbo') }.to change{ User.count }.by(1)
      end

      it 'gives user permission to access guide' do
        user = described_class.invite(email, guide, 'Jimbo')
        user.can_edit? guide
      end
    end

    context 'with user already existing' do
      let(:user) { Fabricate :user  }
      it 'reuses existing user' do
        expect(described_class.invite(user.email, guide, 'Jimbo')).to eq(user)
      end
      it 'gives user permission' do
        described_class.invite(user.email, guide, 'Jimbo')
        user.can_edit? guide
      end
      it 'sends invite email' do
        expect(UserMailer).to receive(:invite)
                              .with(user, guide, 'Jimbo')
                              .and_return(double(deliver_later: true))
        described_class.invite(user.email, guide, 'Jimbo')
      end
    end
  end

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

end
