class Location < ActiveRecord::Base
  audited associated_with: :guide

  belongs_to :guide

  validates :lat, presence: true
  validates :lng, presence: true

  validates :north, presence: true
  validates :south, presence: true
  validates :east, presence: true
  validates :west, presence: true
end
