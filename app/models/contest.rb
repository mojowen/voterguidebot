class Contest < ActiveRecord::Base
  audited associated_with: :guide
  has_associated_audits

  translates :description, :title

  belongs_to :guide
  has_many :candidates, -> { order(position: :asc) }, autosave: true
  has_many :questions, -> { order(position: :asc) }, autosave: true
  has_many :answers, through: :questions
  has_many :endorsements, through: :candidates
  has_many :tags, through: :questions

  delegate :template, to: :guide

  def assign_attributes(attributes)
    @candidate_ids = {}
    create_candidates! attributes
    create_questions! attributes
    super attributes
  end

  def as_json(options = nil)
    super({
      include: { candidates: { include: :endorsements },
                 questions: { include: [:answers, :tags] } },
      methods: :template }.update(options || {}))
  end

  private

  attr_accessor :candidate_ids

  def create_candidates!(associates_obj)
    return unless associates_obj[:candidates]

    associates_obj[:candidates].map!.with_index do |raw_candidate, index|
      candidate_id = raw_candidate[:id].to_s
      raw_candidate.delete(:id) if candidate_id.match /candidate/

      candidate = candidates.find_or_initialize_by(id: raw_candidate[:id])

      candidate_ids[candidate_id] = candidate
      candidate.assign_attributes(raw_candidate)
      candidate.position = index
      candidate
    end
  end

  def create_questions!(associates_obj)
    return unless associates_obj[:questions]

    associates_obj[:questions].map!.with_index do |raw_question, index|
      raw_question.delete :id if raw_question[:id].to_s.match /question/
      question = questions.find_or_initialize_by(id: raw_question[:id])

      raw_answers = raw_question[:answers].clone if raw_question[:answers]
      question.assign_attributes(raw_question)
      question.position = index
      update_candidates!(raw_answers, question) if raw_answers
      question
    end
  end

  def update_candidates!(raw_answers, question)
    raw_answers.each do |raw_answer|
      answer = question.answers.find{ |answer| answer.text == raw_answer[:text] }
      answer.candidate = candidate_ids[raw_answer[:candidate_id].to_s]
    end
  end
end
