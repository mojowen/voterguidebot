class Upload < ActiveRecord::Base
  has_attached_file :file,
    default_url: "/images/robot.png",
    path: "#{Rails.env.test? ? ':rails_root/spec/test_files' : ''}/:guide/:id_:filename",
    restricted_characters: /[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%# '"]/,
    s3_protocol: :https

  belongs_to :user
  belongs_to :guide

  validates_attachment(
    :file,
    presence: true,
    content_type: { content_type: %w(image/jpg image/jpeg image/png image/gif) },
    size: { in: 0..(1.25).megabytes }
  )

  validates :user, presence: true
end
