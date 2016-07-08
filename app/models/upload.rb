class Upload < ActiveRecord::Base
  has_attached_file :file, default_url: "/images/unknown.png"

  belongs_to :user
  belongs_to :guide

  validates_attachment :file, content_type: {
    content_type: %w{image/jpg image/jpeg image/png image/gif} }
  validates_attachment_presence :file

  validates :user, presence: true
end
