require 'rails_helper'

RSpec.describe Measure, type: :model do
  subject { Fabricate :measure }

  context '#assign_attributes' do
    let(:endorsements) do
      [Fabricate.build(:endorsement, endorser: 'great').as_json]
    end
    let(:tags) do
      [Fabricate.build(:tag, name: 'LGBTQ').as_json]
    end
    let(:raw) do
      { title: 'Title', endorsements: endorsements, tags: tags }
    end
    it 'assigns regular attributes' do
      subject.assign_attributes raw
      expect(subject.title).to eq(raw[:title])
    end
    it 'assigns endorsements' do
      subject.assign_attributes raw
      expect(subject.endorsements.first.endorser).to eq(raw[:endorsements].first[:endorser])
    end
    it 'assigns endorsements' do
      subject.assign_attributes raw
      expect(subject.tags.first.name).to eq(raw[:tags].first[:name])
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
        subject.assign_attributes raw.update(endorsements: [endorsements.first])
        expect(subject.endorsements.length).to eq(1)
      end
      it 'reorders endorsements' do
        subject.assign_attributes raw
        subject.save!
        subject.reload
        expect(subject.endorsements.last.id).to eq endorsements.last['id']
        expect(subject.endorsements.last.position).to eq 1
      end
    end
    context 'with already existing tags' do
      let(:endorsements) do
        [
          Fabricate.build(:tag, name: 'LGBTQ').as_json,
          Fabricate(:tag, name: 'Climate Change', tagged: subject ).as_json
        ]
      end
      it 'assigns tags' do
        subject.assign_attributes raw
        expect(subject.tags.first.name).to eq(raw[:tags].first[:name])
      end
      it 'deletes missing tags' do
        subject.assign_attributes raw.update(tags: [tags.first])
        expect(subject.tags.length).to eq(1)
      end
    end
  end
end
