require 'rails_helper'

RSpec.describe Guide, active_mocker: true do
  subject { Fabricate :guide, name: 'My Test Name' }

  describe 'with users' do
    let(:users) { [Fabricate(:user), Fabricate(:user)] }
    let!(:permissions) {
      users.each{ |user| Fabricate :permission, guide: subject, user: user }
    }

    it 'can acess users' do
      expect(subject.users).to eq(users)
    end
  end

  describe '#template' do
    it 'returns the default teplate' do
      expect(subject.template).to eq(Template.default)
    end
  end

  describe '#version' do
    subject { Fabricate :full_guide }
    let!(:version) { subject.version }

    context 'measure' do
      let!(:measure) { subject.measures.first }

      it 'changes version when measures change' do
        measure.update_attributes title: 'different'
        expect(Guide.find(subject.id).version).to_not eq(version)
      end

      it 'changes version when measure tags change' do
        measure.tags << Tag.new(name: 'Root Veigtable')
        expect(Guide.find(subject.id).version).to_not eq(version)
      end

      it 'changes version when measure endorsements change' do
        measure.endorsements << Endorsement.new(endorser: 'NBC')
        expect(Guide.find(subject.id).version).to_not eq(version)
      end
    end

    context 'contest' do
      let!(:contest) { subject.contests.first }

      it 'changes version when measures change' do
        contest.update_attributes title: :Different
        expect(Guide.find(subject.id).version).to_not eq(version)
      end

      context 'question' do
        let!(:question) { contest.questions.first }

        it 'changes version when questions change' do
          question.update_attributes text: :Different
          expect(Guide.find(subject.id).version).to_not eq(version)
        end

        it 'changes version when question tags change' do
          question.tags << Tag.new(name: 'Root Veigtable')
          expect(Guide.find(subject.id).version).to_not eq(version)
        end

        it 'changes version when question answers change' do
          question.answers << Answer.new(text: 'Yes', candidate: contest.candidates.first)
          expect(Guide.find(subject.id).version).to_not eq(version)
        end
      end

      context 'candidate' do
        let!(:candidate) { contest.candidates.first }

        it 'changes version when candidates change' do
          candidate.update_attributes name: :Different
          expect(Guide.find(subject.id).version).to_not eq(version)
        end

        it 'changes version when question tags change' do
          candidate.endorsements << Endorsement.new(endorser: 'Root Veigtable')
          expect(Guide.find(subject.id).version).to_not eq(version)
        end
      end
    end

  end

  describe "#full_clone" do
    subject { Fabricate :full_guide, users: [ Fabricate(:user) ] }

    it 'clones all of the contests and all associated objects' do
      subject.full_clone.contests.each.with_index do |contest, index|
        expect(contest.candidates.length).to eq(subject.contests[index].candidates.length)
        expect(contest.questions.length).to eq(subject.contests[index].questions.length)
        expect(contest.questions[0].answers.length).to eq(subject.contests[index].questions[0].answers.length)
      end
    end

    it 'clones all of the measures' do
      expect(subject.full_clone.measures.length).to eq(subject.measures.length)
    end

    it 'clones all of the fields' do
      subject.full_clone.template_fields.each.with_index do |field, index|
        expect(field[:value]).to eq(subject.template_fields[index][:value])
      end
    end

    it 'clones all of the users' do
      expect(subject.full_clone.users).to eq(subject.users)
    end
  end

  describe '.template_fields' do
    let(:field_template) { subject.template.fields.first['name'] }
    let(:field) { Fabricate :field, value: 'what', field_template: field_template }

    it 'merges the value with the template field' do
      allow(subject).to receive(:fields).and_return([field])
      expect(subject.template_fields.first['value']).to eq(field.value)
    end
  end

  describe '#template_fields=' do
    let(:field_template) { subject.template.fields.first['name'] }
    let(:field_params) { { field_template => 'what'} }
    it 'merges the value with the template field' do
      subject.template_fields = field_params
      expect(subject.template_fields.first['value']).to eq('what')
    end

    context 'already has a value' do
      let!(:field) do
        Fabricate :field,
                  guide: subject,
                  value: 'Nope',
                  field_template: subject.template.fields.first['name']
      end
      it 'merges the value with the template field' do
        subject.template_fields = field_params
        expect(subject.template_fields.first['value']).to eq('what')
      end
    end
  end
end
