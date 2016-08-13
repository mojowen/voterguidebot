require 'rails_helper'

RSpec.describe Measure, type: :model do
  subject { Fabricate :measure }

  describe "#full_clone" do
    let!(:tag) { Fabricate :tag, tagged: subject }
    let!(:endorsement) { Fabricate :endorsement, endorsed: subject }

    let!(:clone) { subject.full_clone }
    before(:each) { clone.save }

    it 'clones the title' do
      expect(clone.title).to eq(subject.title)
    end
    it 'clones the description' do
      expect(clone.description).to eq(subject.description)
    end
    it 'clones the yes_means' do
      expect(clone.yes_means).to eq(subject.yes_means)
    end
    it 'clones the no_means' do
      expect(clone.no_means).to eq(subject.no_means)
    end
    it 'clones the stance' do
      expect(clone.stance).to eq(subject.stance)
    end
    it 'clones the endorsements' do
      expect(clone.endorsements.first.endorser).to eq(endorsement.endorser)
      expect(clone.endorsements.first.endorsed_id).to_not eq(subject.id)
    end
    it 'clones the tags' do
      expect(clone.tags.first.name).to eq(tag.name)
      expect(clone.tags.first.tagged_id).to_not eq(subject.id)
    end
  end
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
