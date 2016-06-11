class Question < ActiveRecord::Base
  audited associated_with: :guide

  translates :text
  belongs_to :contest
  has_one :guide, through: :contest

  has_many :answers, dependent: :destroy
end
