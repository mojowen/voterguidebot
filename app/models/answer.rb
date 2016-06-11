class Answer < ActiveRecord::Base
  audited associated_with: :guide

  translates :text

  belongs_to :candidate
  belongs_to :question
  has_one :contest, through: :question
  has_one :guide, through: :contest

  validates_presence_of :candidate
  validates_presence_of :question
  validates_presence_of :text
end
