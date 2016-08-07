require 'rails_helper'

RSpec.describe Template do
  subject { described_class.new 'default' }

  describe 'sub template inherits from parent template' do
    subject { described_class.new 'small' }
    let(:default) { described_class.new 'default' }

    it 'inherits properties not defined' do
      expect(subject.tags).to eq(default.tags)
    end

    it 'overrides defined properties' do
      expect(subject.contests).to_not eq(default.contests)
    end
  end

  describe '.default initalizes from template' do
    let(:config) { YAML.load_file Rails.root.join('config','templates', 'default.yml') }
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
    it 'has a question tags' do
      expect(subject.tags).to eq(config['tags'])
    end
    it 'has a question seeds' do
      expect(subject.questions['samples']).to eq(config['questions']['samples'])
    end
  end

  describe '#fields' do
    describe 'each field' do
      it 'has a label' do
        subject.fields.each do |field|
          expect(field['label']).to_not be_falsey
        end
      end
      it 'has an example' do
        subject.fields.each do |field|
          expect(field['example']).to_not be_falsey
        end
      end
      it 'has a limit if not image' do
        subject.fields.each do |field|
          next if field['element'] == 'ImageComponent'
          expect(field['limit']).to_not be_falsey
        end
      end
      it 'has an element' do
        subject.fields.each do |field|
          expect(field['element']).to_not be_falsey
        end
      end
    end
  end
end
