class Candidate < ActiveRecord::Base
  audited associated_with: :contest

  translates :bio
  belongs_to :contest

  has_many :answers, dependent: :destroy
  has_many :endorsements, dependent: :destroy
end
