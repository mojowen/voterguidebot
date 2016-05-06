require 'rails_helper'

RSpec.describe Permission, active_mocker: true do
  let(:user) { Fabricate :user }
  let(:guide) { Fabricate :guide }
  subject { described_class.create! user: user, guide: guide }

  it 'has a user' do
    expect(subject.user).to eq(user)
  end
  it 'has a guide' do
    expect(subject.guide).to eq(guide)
  end
end
