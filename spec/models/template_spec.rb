require 'rails_helper'

RSpec.describe Template do
  subject { described_class.new 'default' }

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
     described_class.new('default').fields.each do |field|
      it "#{field['name']} has a label" do
        expect(field['label']).to_not be_falsey
      end
      it "#{field['name']} has an example or default" do
        expect(field['example'] || field['default']).to_not be_falsey
      end
      it "#{field['name']} has a limit if not image" do
        next if %w(ImageComponent SelectComponent).include? field['element']
        next if field['type'] == 'color'
        expect(field['limit']).to_not be_falsey
      end
      it "#{field['name']} default is not more than limit" do
        next if %w(ImageComponent SelectComponent).include? field['element']
        next if field['type'] == 'color'
        next unless field['default']
        default = field['default']
        default = default.split('{').first + default.split('}').last if field['clear_brackets']
        expect(field['limit'] > default.length).to be_truthy
      end
      it "#{field['name']} has an element" do
        expect(field['element']).to_not be_falsey
      end
    end
  end
end
