require 'rails_helper'

RSpec.describe Question, type: :model do

  context '#assign_attributes' do
    let(:candidate_id) { Fabricate(:candidate).id }
    let(:tags) do
      [Fabricate.build(:tag, name: 'LBTQ').as_json]
    end
    let(:answers) do
      [Fabricate.build(:answer, text: 'Yes', candidate_id: candidate_id, question: subject).as_json]
    end
    let(:raw) do
      { text: 'Thing here', tags: tags, answers: answers }.with_indifferent_access
    end
    it 'assigns regular attributes' do
      subject.assign_attributes raw
      expect(subject.text).to eq(raw[:text])
    end

    it 'assigns tags' do
      subject.assign_attributes raw
      expect(subject.tags.first.name).to eq(raw[:tags].first[:name])
    end
    context 'with already existing tags' do
      let(:tags) do
        [
          Fabricate.build(:tag, name: 'LGBTQ').as_json,
          Fabricate(:tag, name: 'Climate Change', tagged: subject).as_json
        ]
      end
      it 'assigns tags' do
        subject.assign_attributes raw
        expect(subject.tags.last.name).to eq(raw[:tags].first[:name])
      end
      it 'deletes missing tags' do
        subject.assign_attributes raw.update(tags: [tags.first]).with_indifferent_access
        expect(subject.tags.length).to eq(1)
      end
    end

    it 'assigns answers' do
      subject.assign_attributes raw
      expect(subject.answers.first.text).to eq(raw[:answers].first[:text])
    end
    context 'with already existing answers' do
      let(:answers) do
        [
          Fabricate(:answer, text: 'Yes', candidate_id: candidate_id, question: subject).as_json
        ]
      end
      it 'assigns answers' do
        subject.assign_attributes raw.update(answers: [answers.first.update(text: 'No')])
        expect(subject.answers.last.text).to eq('No')
      end
      it 'deletes missing tags' do
        subject.assign_attributes raw.update(answers: []).with_indifferent_access
        expect(subject.answers.length).to eq(0)
      end
    end
  end
end
