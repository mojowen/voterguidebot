require 'rails_helper'

RSpec.describe Measure, type: :model do
  subject { Fabricate :measure }

  context '#assign_attributes' do
    let(:endorsements) do
      [Fabricate.build(:endorsement, endorser: 'great').as_json]
    end
    let(:raw) do
      { title: 'Title', endorsements: endorsements }.with_indifferent_access
    end
    it 'assigns regular attributes' do
      subject.assign_attributes raw
      expect(subject.title).to eq(raw[:title])
    end
    it 'assigns endorsements' do
      subject.assign_attributes raw
      expect(subject.endorsements.first.endorser).to eq(raw[:endorsements].first[:endorser])
    end
    context 'with already existing endorsements' do
      let(:endorsements) do
        [
          Fabricate.build(:endorsement, endorser: 'great', stance: 'for').as_json,
          Fabricate(:endorsement, endorser: 'great', stance: 'for', endorsed: subject ).as_json
        ]
      end
      it 'assigns endorsements' do
        subject.assign_attributes raw
        expect(subject.endorsements.first.endorser).to eq(raw[:endorsements].first[:endorser])
      end
      it 'deletes missing endorsements' do
        subject.assign_attributes raw.update(endorsements: [endorsements.first]).with_indifferent_access
        expect(subject.endorsements.length).to eq(1)
      end
    end
  end
end
