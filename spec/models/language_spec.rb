require 'rails_helper'

RSpec.describe Language, type: :model do
  subject { Fabricate :language }

  it 'uses the code to print a nice name' do
    expect(subject.name).to eq('Spanish')
  end
end
