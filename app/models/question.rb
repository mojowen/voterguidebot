class Question < ActiveRecord::Base
  audited associated_with: :guide

  translates :text
  belongs_to :contest
  has_one :guide, through: :contest

  has_many :answers, dependent: :destroy, autosave: true
  include Tags

  def assign_attributes(attributes)
    create_tags! attributes
    create_answers! attributes
    super attributes
  end

  private

  def create_answers!(attributes)
    return unless attributes[:answers]
    attributes[:answers].map! do |raw_answer|
      answers.find_or_initialize_by(
        text: raw_answer[:text],
        candidate_id: raw_answer[:candidate_id])
    end
  end
end
