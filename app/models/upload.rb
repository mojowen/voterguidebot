class Upload < ActiveRecord::Base
  has_attached_file :file,
    default_url: "/images/robot.png",
    path: "#{Rails.env.test? ? ':rails_root/spec/test_files' : ''}/:guide/:id_:filename",
    s3_protocol: :https

  belongs_to :user
  belongs_to :guide

  validates_attachment :file, content_type: {
    content_type: %w{image/jpg image/jpeg image/png image/gif} }
  validates_attachment_presence :file

  validates :user, presence: true
end
