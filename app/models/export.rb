require 'zip'

class Export < ActiveRecord::Base
  belongs_to :user
  has_many :export_guides, autosave: true, dependent: :destroy
  has_many :guides, through: :export_guides

  enum status: %w{unpublished publishing published failed}

  validates :guides, presence: true

  def key
    "exports/#{id}/download.pdf"
  end

  def url
    @url ||= s3.object(zip_key).presigned_url(:get, expires_in: 3600 * 24 * 7)
  end

  def start_publishing
    self.status = :publishing
    save!
    Delayed::Job.enqueue PublishJob.new(self)
  end

  def publish
    download_zip_upload_and_notify
    rescue StandardError => error
    abort_and_notify
    raise error
  end

  def is_synced?
    !export_guides.any? do |export_guide|
      return false unless export_guide.export_version
      export_guide.export_version != export_guide.guide.published_version
    end
  end

  private

  def abort_and_notify
    UserMailer.export(user, self, failed: true).deliver_later
    update_attributes status: :failed
    clean
  end

  def download_zip_upload_and_notify
    FileUtils.mkdir_p export_path

    download_guides
    zip_archive_folder
    upload_zip_arhive
    clean
    UserMailer.export(user, self).deliver_later

    self.status = :published
    save!
  end

  def download_guides
    FileUtils.mkdir_p guides_path

    export_guides.each { |export_guide| download_guide(export_guide) }
  end

  def download_guide(export_guide)
    guide = export_guide.guide
    export_guide.export_version = guide.published_version

    pdf_path = Rails.root.join(guides_path, "#{guide.slug}.pdf")
    s3.download_file pdf_path, guide.s3_key

    rescue S3Wrapper::DownloadFailed
    export_guide.fail!
  end

  def zip_archive_folder
    ::Zip::File.open(zip_path, ::Zip::File::CREATE) do |zipfile|
      Dir[Rails.root.join(guides_path, '*.pdf')].each do |filename|
        zipfile.add(File.basename(filename), filename)
      end
    end
  end

  def upload_zip_arhive
    s3.upload_file(zip_path, zip_key)
  end

  def clean
    FileUtils.remove_dir export_path
  end

  def zip_key
    "exports/export-#{id}/export.zip"
  end

  def export_path
    @export_path ||= Rails.root.join('tmp', 'exports', Time.now.getutc.to_i.to_s)
  end

  def zip_path
    @zip_path ||= Rails.root.join(export_path, 'export.zip')
  end

  def guides_path
    @guides_path ||= Rails.root.join(export_path, 'guides')
  end

  def s3
    @s3 ||= S3Wrapper.new
  end
end
