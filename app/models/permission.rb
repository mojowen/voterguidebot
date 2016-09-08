class Permission < ActiveRecord::Base
  belongs_to :guide
  belongs_to :user

  validates :user, presence: true
  validates :guide, presence: true, uniqueness: { scope: :user_id }
end
