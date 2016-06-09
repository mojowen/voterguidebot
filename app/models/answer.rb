class Answer < ActiveRecord::Base
  audited associated_with: :question

  translates :text

  belongs_to :candidate
  belongs_to :question

  validates_presence_of :candidate
  validates_presence_of :question
  validates_presence_of :text
end
