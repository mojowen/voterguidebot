require 'rails_helper'

RSpec.describe Template do
  subject { described_class.default }

  describe '.default initalizes from template' do
    let(:config) { YAML.load_file Rails.root.join('config','template.yml') }
    it 'with contests' do
      expect(subject.contests).to eq(config['contests'])
    end
    it 'with candidates' do
      expect(subject.candidates).to eq(config['candidates'])
    end
    it 'with endorsements' do
      expect(subject.endorsements).to eq(config['endorsements'])
    end
    it 'with questions' do
      expect(subject.questions).to eq(config['questions'])
    end
    it 'with ballot_measures' do
      expect(subject.ballot_measures).to eq(config['ballot_measures'])
    end
    it 'with fields' do
      expect(subject.fields).to eq(config['fields'])
    end
    it 'has a name' do
      expect(subject.name).to eq(config['name'])
    end
  end

  describe '#fields' do
    describe 'each field' do
      it 'has a label' do
        subject.fields.each do |field|
          expect(field[:label]).to_not be_falsey
        end
      end
      it 'has an example' do
        subject.fields.each do |field|
          expect(field[:example]).to_not be_falsey
        end
      end
      it 'has a limit if not image' do
        subject.fields.each do |field|
          next if field[:element] == 'ImageComponent'
          expect(field[:limit]).to_not be_falsey
        end
      end
      it 'has an element' do
        subject.fields.each do |field|
          expect(field[:element]).to_not be_falsey
        end
      end
    end
  end
end
