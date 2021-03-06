require 'rails_helper'

RSpec.describe Contest, type: :model do
  subject { Fabricate :contest }

  describe "#full_clone" do
    let!(:candidate) { Fabricate :candidate, contest: subject }
    let!(:question) { Fabricate :question, contest: subject }
    let!(:answer) { Fabricate :answer, candidate: candidate, question: question }
    let!(:endorsement) { Fabricate :endorsement, endorsed: candidate }
    let!(:tag) { Fabricate :tag, tagged: question }

    let!(:clone) { subject.full_clone }
    before(:each) { clone.save }

    it 'clones the title' do
      expect(clone.title).to eq(subject.title)
    end
    it 'clones the description' do
      expect(clone.description).to eq(subject.description)
    end
    it 'clones the candidates' do
      expect(clone.candidates.first.name).to eq(candidate.name)
      expect(clone.candidates.first.id).to_not eq(candidate.id)
    end
    it 'clones the questions' do
      expect(clone.questions.first.text).to eq(question.text)
      expect(clone.questions.first.id).to_not eq(question.id)
    end
    it 'clones the answers' do
      expect(clone.answers.first.text).to eq(answer.text)
      expect(clone.answers.first.question_id).to_not eq(question.id)
      expect(clone.answers.first.candidate_id).to_not eq(candidate.id)
    end
    it 'clones the endorsements' do
      expect(clone.endorsements.first.endorser).to eq(endorsement.endorser)
      expect(clone.endorsements.first.endorsed_id).to_not eq(candidate.id)
    end
    it 'clones the tags' do
      expect(clone.tags.first.name).to eq(tag.name)
      expect(clone.tags.first.tagged_id).to_not eq(question.id)
    end
  end

  describe '#assign_attributes' do
    it 'creates candidates' do
      raw_obj = { candidates: [{ id: 'candidate5', name: 'Frank' }] }
      subject.assign_attributes raw_obj
      expect(subject.candidates.first.name).to eq('Frank')
    end
    context 'with a candidate' do
      let!(:candidate) { Fabricate :candidate, contest: subject, name: 'Bill' }
      it 'updates candidates' do
        raw_obj = { candidates: [{ id: candidate.id, name: 'Frank' }] }
        subject.assign_attributes raw_obj
        expect(subject.candidates.first.name).to eq('Frank')
      end
      it 'deletes candidates' do
        raw_obj = { candidates: [] }
        subject.assign_attributes raw_obj
        expect(subject.candidates).to be_empty
      end
      it 'reorders candidates' do
        raw_obj = { candidates: [{ id: 'candidate5' },
                                 { id: candidate.id }] }
        subject.assign_attributes raw_obj
        subject.save!
        subject.reload
        expect(subject.candidates.last.id).to eq candidate.id
        expect(subject.candidates.last.position).to eq 1
      end
    end

    it 'creates questions' do
      raw_obj = { questions: [{ id: 'question5', text: 'WHAT ARE THOSE' }] }
      subject.assign_attributes raw_obj
      expect(subject.questions.first.text).to eq('WHAT ARE THOSE')
    end
    context 'with a question' do
      let!(:question) { Fabricate :question, contest: subject, text: 'WHAT ARE THOSE' }
      it 'updates questions' do
        raw_obj = { questions: [{ id: question.id, text: 'WHAT ARE THOSE' }] }
        subject.assign_attributes raw_obj
        expect(subject.questions.first.text).to eq('WHAT ARE THOSE')
      end
      it 'deletes questions' do
        raw_obj = { questions: [] }
        subject.assign_attributes raw_obj
        expect(subject.questions).to be_empty
      end
      it 'reorders questions' do
        raw_obj = { questions: [{ id: 'question5' },
                                { id: question.id, text: 'WHAT ARE THOSE' }] }
        subject.assign_attributes raw_obj
        subject.save!
        subject.reload
        expect(subject.questions.last.id).to eq question.id
        expect(subject.questions.last.position).to eq 1
      end
    end

    context 'with endorsers' do
      let(:endorsed_id) { 'candidate2' }
      let(:endorsement) do
        { endorsed_id: endorsed_id,
          endorsing_type: 'candidate',
          endorser: 'Dudes for Dude Stuff' }
      end
      let(:raw_obj) do
        { candidates: [{ id: endorsed_id, endorsements: [endorsement] }] }
      end

      it 'creates new endorsers' do
        subject.assign_attributes raw_obj
        subject.save!
        expect(subject.endorsements.first.endorsed).to eq(
          subject.candidates.first)
      end
      context 'with existing candidate' do
        let!(:candidate) { Fabricate :candidate, contest: subject }
        let(:endorsed_id) { candidate.id }
        it 'associates with existing candidate' do
          subject.assign_attributes raw_obj
          subject.save!
          expect(subject.endorsements.first.endorsed).to eq(candidate)
        end
      end
      context 'with existing candidate' do
        let(:candidate) { Fabricate :candidate, contest: subject }
        let(:endorsed_id) { candidate.id }
        let!(:endorsement) do
          Fabricate(:endorsement, endorsed: candidate, endorser: 'what')
            .as_json
            .with_indifferent_access
        end

        it 'updates endorsers' do
          subject.assign_attributes raw_obj
          subject.save!
          expect(subject.endorsements.first.id).to eq(endorsement[:id])
          expect(subject.reload.endorsements.first.endorser).to eq(endorsement[:endorser])
        end
        it 'deletes unused endorsers' do
          subject.assign_attributes({ candidates: [{ id: endorsed_id, endorsements: [] }] })
          expect(subject.reload.endorsements).to be_empty
        end
      end
    end

    context 'with tags' do
      let(:question_id) { 'question2' }
      let(:tag) do
        { tagged_id: question_id,
          tagged_type: 'question',
          name: 'LGTBQ' }
      end
      let(:raw_obj) do
        { questions: [{ id: question_id, tags: [tag] }] }
      end

      it 'creates new tags' do
        subject.assign_attributes raw_obj
        subject.save!
        expect(subject.tags.first.tagged).to eq(
          subject.questions.first)
      end
      context 'with existing question' do
        let!(:question) { Fabricate :question, contest: subject }
        let(:question_id) { question.id }
        it 'associates with existing question' do
          subject.assign_attributes raw_obj
          subject.save!
          expect(subject.tags.first.tagged).to eq(question)
        end
      end
      context 'with existing question tag' do
        let(:question) { Fabricate :question, contest: subject }
        let(:question_id) { question.id }
        let!(:existing_tag) { Fabricate :tag, tagged: question, name: 'LGTBQ' }
        it 'updates endorsers' do
          subject.assign_attributes raw_obj
          expect(subject.tags.first.id).to eq(existing_tag.id)
          expect(subject.reload.tags.first.tagged).to eq(question)
        end
        it 'deletes unused endorsers' do
          subject.assign_attributes({ questions: [{ id: question_id, tags: [] }] })
          subject.save!
          expect(subject.reload.tags).to be_empty
        end
      end
    end

    context 'with answers' do
      let(:question_id) { 'question5' }
      let(:candidate_id) { 'candidate2' }
      let(:answer) do
        { question_id: question_id,
          candidate_id: candidate_id,
          text: 'whaaat' }
      end
      let(:raw_obj) do
        { questions: [{ id: question_id, answers: [answer.as_json.with_indifferent_access] }],
          candidates: [{ id: candidate_id}] }
      end

      it 'creates new answers from new candidates and questions' do
        subject.assign_attributes raw_obj
        subject.save!
        expect(subject.answers.first.question).to eq(subject.questions.first)
        expect(subject.answers.first.candidate).to eq(subject.candidates.first)
      end

      context 'with an existing question' do
        let(:question) { Fabricate :question, contest: subject }
        let(:question_id) { question.id }
        it 'associates appropriately' do
          subject.assign_attributes raw_obj
          subject.save!
          expect(subject.answers.first.question).to eq(question)
        end
      end

      context 'with an existing candidate' do
        let(:candidate) { Fabricate :candidate, contest: subject }
        let(:candidate_id) { candidate.id }
        it 'associates appropriately' do
          subject.assign_attributes raw_obj
          subject.save!
          expect(subject.answers.first.candidate).to eq(candidate)
        end
      end

      context 'with an existing answer' do
        let(:question) { Fabricate :question, contest: subject }
        let(:question_id) { question.id }
        let(:candidate) { Fabricate :candidate, contest: subject }
        let(:candidate_id) { candidate.id }
        let!(:answer) { Fabricate :answer, text: 'What', question: question,
                                           candidate: candidate }

        it 'updates answers' do
          raw_obj[:questions].first[:answers].first.update(text: 'Different')
          subject.assign_attributes raw_obj
          subject.save
          expect(subject.reload.answers.first.id).to eq(answer.id)
          expect(subject.reload.answers.first.text).to eq('Different')
        end

        it 'deletes unused answers' do
          raw_obj[:questions].first.update(answers: [])
          subject.assign_attributes raw_obj
          expect(subject.reload.answers).to be_empty
        end

        context 'with a new answer' do
          let(:new_candidate_id) { 'candidate_1' }
          let(:new_answer) do
            { question_id: question_id,
              candidate_id: new_candidate_id,
              text: answer.text }
          end
          let(:raw_obj) do
            { questions: [{ id: question_id, answers: [answer.as_json.with_indifferent_access, new_answer] }],
              candidates: [{ id: candidate_id}, { id: new_candidate_id }] }
          end

          it 'adds both the new candidate and new answer' do
            subject.assign_attributes raw_obj
            subject.save!

            expect(subject.answers.length).to eq(2)
            expect(subject.candidates.length).to eq(2)
            expect(subject.answers.first.candidate).to eq(subject.candidates.first)
            expect(subject.answers.last.candidate).to eq(subject.candidates.last)
          end
        end
      end
    end
  end
end
