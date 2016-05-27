require 'rails_helper'

RSpec.describe Field, type: :model do
  subject { Fabricate :field }
  it 'has a guide' do
    expect(subject.guide).to_not be_falsey
  end
  it 'has a template' do
    expect(subject.template).to_not be_falsey
  end
  it 'has a field template' do
    expect(subject.field_template).to_not be_falsey
  end
end
