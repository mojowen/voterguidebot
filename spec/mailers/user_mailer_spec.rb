require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe '#invite' do
    let(:user) { Fabricate :user }
    let(:guide) { Fabricate :guide, users: [user] }
    let(:invitee) { 'Jimbo' }
    subject { described_class.invite(user, guide, invitee) }

    it 'renders invite template with guide name' do
      expect(subject.body.encoded).to match(guide.name)
    end

    it 'renders invite template with guide path' do
      expect(subject.body.encoded).to match(guide_path(guide))
    end

    it 'sends to user' do
      expect(subject.to).to eq([user.email])
    end
  end

  describe '#welcome' do
    let(:user) { Fabricate :user, first_name: 'Blob' }

    subject { described_class.welcome(user) }

    it 'renders invite template' do
      expect(subject.body.encoded).to match(user.first_name)
    end

    it 'sends to user' do
      expect(subject.to).to eq([user.email])
    end
  end
  describe '#welcome' do
    let(:user) { Fabricate :user, first_name: 'Blob' }
    let(:admins) { [Fabricate(:user, admin: true), Fabricate(:user, admin: true)] }

    subject { described_class.promote(user, admins.first) }

    it 'renders promote template' do
      expect(subject.body.encoded).to match(user.first_name)
    end

    it 'sends to user' do
      expect(subject.to).to eq([user.email])
    end

    it 'ccs admin' do
      expect(subject.cc).to eq(admins.map(&:email))
    end
  end
end
