require 'rails_helper'

RSpec.describe Publisher::Conducter do
  let!(:guide) { Fabricate :guide }
  subject { described_class.new(guide) }

  let(:uploader) { instance_double(S3Wrapper) }

  describe '#publish' do
    it 'calls StaticRenderer, PhantomRenderer, and S3Wrapper' do
      expect_any_instance_of(Publisher::PDF).to receive(:publish)
      subject.publish
    end
  end

  describe '#resource' do
    it 'calls StaticRenderer, PhantomRenderer, and S3Wrapper' do
      expect_any_instance_of(Publisher::PDF).to receive(:resource)
      subject.resource
    end
  end
end
