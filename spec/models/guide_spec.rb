require 'rails_helper'

RSpec.describe Guide, active_mocker: true do
  subject { described_class.new name: 'My Test Name' }

  context 'with users' do
    let(:users) { [Fabricate(:user), Fabricate(:user)] }
    let!(:permissions) {
      users.each{ |user| Fabricate :permission, guide: subject, user: user }
    }

    it 'can acess users' do
      expect(subject.users).to eq(users)
    end
  end
end
