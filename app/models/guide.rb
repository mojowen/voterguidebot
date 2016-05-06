class Guide < ActiveRecord::Base
  has_many :permissions
  has_many :users, through: :permissions

  validates :name, presence: true
end
