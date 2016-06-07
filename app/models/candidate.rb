class Candidate < ActiveRecord::Base
  translates :bio
  belongs_to :contest

  has_many :answers, dependent: :destroy
  has_many :endorsements, dependent: :destroy
end
