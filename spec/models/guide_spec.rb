require 'rails_helper'

RSpec.describe Guide, active_mocker: true do
  subject { described_class.new name: 'My Test Name' }

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
