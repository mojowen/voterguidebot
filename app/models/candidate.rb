class Candidate < ActiveRecord::Base
  audited associated_with: :guide

  translates :bio
  belongs_to :contest
  has_one :guide, through: :contest

  has_many :answers, dependent: :destroy
  has_many :endorsements, as: :endorsing, dependent: :destroy
end
