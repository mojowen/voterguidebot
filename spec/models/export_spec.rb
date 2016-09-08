require 'rails_helper'

RSpec.describe Export, type: :model do
  let!(:guide) { Fabricate :guide, published_version: 'diff' }

  describe '#start_publishing' do
    subject { Fabricate :export }

    it 'creates a delayed job' do
      expect do
        subject.start_publishing
      end.to change(Delayed::Job, :count).by(1)
    end

    it 'sets status to publishing' do
      subject.start_publishing
      expect(subject.publishing?).to eq true
    end
  end

  describe '#publish' do
    subject { Fabricate :export, guides: [guide] }
    let(:s3_object) { double(presigned_url: 'http://some-s3-route.org/thing.zip') }
    let(:s3_wrapper) do
      instance_double(S3Wrapper, upload_file: nil, object: s3_object)
    end
    let(:export_path) { Rails.root.join(*%w(spec test_files export)) }

    before(:each) do
      allow(s3_wrapper).to receive(:download_file) { |path, _| FileUtils.touch path }
      allow(subject).to receive(:s3).and_return(s3_wrapper)
      allow(subject).to receive(:export_path).and_return(export_path)
    end

    context 'when publishing' do
      before(:each) do
        allow(subject).to receive(:clean)
        subject.publish
      end
      after(:each) { FileUtils.rm_r(export_path) if File.exists?(export_path) }

      it 'downloads all the guides into a tmp folder' do
        guide_path = Rails.root.join(export_path, 'guides', "#{guide.slug}.pdf")
        expect(File.exist?(guide_path)).to be true
      end

      it 'notes the guide versions on export_guide' do
        expect(subject.export_guides.first.export_version).to eq(guide.published_version)
      end

      it 'creates a zip file' do
        expect(File.exist?(Rails.root.join(export_path, 'export.zip'))).to be true
      end
    end

    it 'calls upload on zip file' do
      expect(s3_wrapper).to receive(:upload_file).with(
        Rails.root.join(export_path, 'export.zip'), "exports/export-#{subject.id}/export.zip")
      subject.publish
    end

    it 'sends email if successful' do
      expect(UserMailer).to receive(:export).with(subject.user, subject).and_call_original
      subject.publish
    end
    it 'sends email if failed' do
      allow(s3_wrapper).to receive(:upload_file).and_raise(StandardError)
      expect do
        expect(UserMailer).to receive(:export).with(subject.user, subject, failed: true).and_call_original
        subject.publish
      end.to raise_error
    end

    context 'when S3 cannot find the file' do
      before(:each) do
        allow(s3_wrapper).to receive(:download_file)
          .and_raise(S3Wrapper::DownloadFailed)
        allow(subject).to receive(:s3).and_return(s3_wrapper)
        allow(subject).to receive(:export_path).and_return(export_path)
      end

      it 'does not stop publishing' do
        subject.publish
        expect(subject.published?).to be true
        expect(subject.export_guides.first.export_version).to eq('not-published')
      end
    end
  end

  describe '#is_synced?' do
    let!(:guide) { Fabricate :guide, published_version: 'diff' }
    subject { Fabricate :export, guides: [guide] }

    it 'returns false if export_gudies are all nil' do
      expect(subject.is_synced?).to be false
    end

    it 'returns true if export_guides match guides version' do
      subject.export_guides.first.update_attributes export_version: guide.published_version
      expect(subject.is_synced?).to be true
    end

    it 'returns false if export_gudies do not match guides version'  do
      subject.export_guides.first.update_attributes export_version: guide.published_version
      guide.update_attributes published_version: 'what'
      expect(subject.is_synced?).to be false
    end
  end
end
