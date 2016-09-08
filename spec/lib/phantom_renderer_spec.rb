require 'rails_helper'

RSpec.describe PhantomRenderer do
  subject { described_class.new test_html_file }
  let(:test_tmp) { Rails.root.join(*%w(spec test_files)) }
  let(:test_html_file) { Rails.root.join(*%w(spec fixtures test.html)) }

  describe '#render' do
    it 'creates a pdf' do
      filepath = Rails.root.join(test_tmp, 'test.pdf')
      subject.render(path: filepath)
      expect(File.exists?(filepath)).to be true
    end

    it 'creates a png' do
      filepath = Rails.root.join(test_tmp, 'test.png')
      subject.render(path: filepath)
      expect(File.exists?(filepath)).to be true
    end
  end

  describe '#upload' do
    let(:uploader) { instance_double(S3Wrapper) }

    before(:each) do
      expect(subject).to receive(:phantom)
      class_double("S3Wrapper", new: uploader).as_stubbed_const
    end

    it 'calls s3' do
      expect(uploader).to receive(:upload_file_if_changed).with(Rails.root.join('tmp', 'test.pdf'), nil)
      subject.render.upload
    end
  end

  describe '.render_and_upload' do
    let(:uploader) { instance_double(S3Wrapper) }
    before(:each) do
      class_double("S3Wrapper", new: uploader).as_stubbed_const
    end
    after(:each) do
      File.delete Rails.root.join('tmp', 'test.pdf')
    end

    it 'creates a png and passes it to s3' do
      expect(uploader).to receive(:upload_file_if_changed)
        .with(Rails.root.join('tmp', 'test.pdf'), 'my-file.png')
      described_class.render_and_upload(test_html_file, extenion: :png, key: 'my-file.png')
    end

    it 'creates a pdf and passes it to s3' do
      expect(uploader).to receive(:upload_file_if_changed)
        .with(Rails.root.join('tmp', 'test.pdf'), nil)
      described_class.render_and_upload(test_html_file)
    end

    it 'uses specified bucket' do
      expect(S3Wrapper).to receive(:new).with('my-bucket')
      allow(uploader).to receive(:upload_file_if_changed)
      described_class.render_and_upload(test_html_file, bucket: 'my-bucket')
    end
  end
end
