class Upload < ActiveRecord::Base
  has_attached_file :file,
    default_url: "/images/robot.png",
    path: "#{Rails.env.test? ? ':rails_root/spec/test_files' : ''}/:guide/:id_:filename",
    restricted_characters: /[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%# '"]/,
    s3_protocol: :https

  belongs_to :user
  belongs_to :guide

  validates_attachment_content_type :file, content_type: %w(image/jpg image/jpeg image/png image/gif)
  validates_attachment_presence :file
  validates_attachment_size :file, in: 0..(1.5).megabytes, message: "File must be smaller than 1.5 MB"

  validates :user, presence: true
  validates :guide, presence: true
end
