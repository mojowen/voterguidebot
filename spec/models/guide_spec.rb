require 'rails_helper'

RSpec.describe Guide, active_mocker: true do
  subject { Fabricate :guide, name: 'My Test Name' }

  context 'with users' do
    let(:users) { [Fabricate(:user), Fabricate(:user)] }
    let!(:permissions) {
      users.each{ |user| Fabricate :permission, guide: subject, user: user }
    }

    it 'can acess users' do
      expect(subject.users).to eq(users)
    end
  end

  context '#template' do
    it 'returns the default teplate' do
      expect(subject.template).to eq(Template.default)
    end
  end

  context '#template_questions' do
    it 'returns a list of question hashes' do
      expect(subject.template_questions.length).to eq(
        subject.template.question_seeds.length)
    end
    it 'returns a list of question with fake ids' do
      expect(subject.template_questions.first['id']).to eq('0question')
    end
    it 'returns a list of questions with tags' do
      expect(subject.template_questions.first['tags'].first['name']).to eq(
        subject.template.question_seeds.first['tag'])
    end
  end

  context '.template_fields' do
    let(:field_template) { subject.template.fields.first[:name] }
    let(:field) { Fabricate :field, value: 'what', field_template: field_template }
    it 'merges the value with the template field' do
      allow(subject).to receive(:fields).and_return([field])
      expect(subject.template_fields.first[:value]).to eq(field.value)
    end
  end

  context '#template_fields=' do
    let(:field_template) { subject.template.fields.first[:name] }
    let(:field_params) { { field_template => 'what'} }
    it 'merges the value with the template field' do
      subject.template_fields = field_params
      expect(subject.template_fields.first[:value]).to eq('what')
    end
  end
end
