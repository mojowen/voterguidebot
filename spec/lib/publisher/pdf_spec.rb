require 'rails_helper'

RSpec.describe Publisher::PDF do
  let!(:guide) { Fabricate :guide }
  subject { described_class.new(guide) }

  let(:uploader) { instance_double(S3Uploader) }

  describe '#publish' do
    it 'calls StaticRenderer, PhantomRenderer, and S3Uploader' do
      expect(StaticRenderer).to receive(:render_file)
      expect(PhantomRenderer).to receive(:new).and_call_original
      expect_any_instance_of(PhantomRenderer).to receive(:render)
      expect(S3Uploader).to receive(:new).and_return(uploader)
      expect(uploader).to receive(:upload_file_if_changed)
      subject.publish
    end
  end

  describe '#resource' do
    let(:s3_object) { double }

    it 'calls S3Uploader, retrieves the s3 object, and retrieves a url' do
      expect(S3Uploader).to receive(:new).and_return(uploader)
      expect(uploader).to receive(:object).and_return(s3_object)
      expect(s3_object).to receive(:presigned_url)
      subject.resource
    end
  end
end
