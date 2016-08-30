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

  def full_clone
    cloned = dup

    @candidate_ids = Hash[ candidates.map { |cand| [cand.id, cand.dup] } ]
    cloned.candidates = candidate_ids.values
    cloned.candidates.each.with_index do |candidate, index|
      candidate.endorsements = candidates[index].endorsements.map(&:dup)
    end

    cloned.questions = questions.map do |question|
      cloned_question = question.dup
      cloned_question.tags = question.tags.map(&:dup)
      cloned_question.answers = question.answers.map do |answer|
        cloned_answer = answer.dup
        cloned_answer.question = cloned_question
        cloned_answer.candidate = candidate_ids[answer.candidate_id]
        cloned_answer
      end
      cloned_question
    end

    cloned
  end

  private

  attr_accessor :candidate_ids

  def create_candidates!(associates_obj)
    return unless associates_obj[:candidates]

    associates_obj[:candidates].map!.with_index do |raw_candidate, index|
      candidate_id = raw_candidate[:id].to_s
      raw_candidate.delete(:id) if candidate_id.match /candidate/

      candidate = candidates.find_or_initialize_by(id: raw_candidate[:id])

      candidate_ids[candidate_id.to_s] = candidate
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

      question.answers = update_candidates!(raw_question.delete(:answers), question)
      question.assign_attributes(raw_question)
      question.position = index
      question
    end
  end

  def update_candidates!(raw_answers, question)
    return [] unless raw_answers

    raw_answers.map do |raw_answer|
      answer = question.answers.find_or_initialize_by(id: raw_answer[:id])
      answer.text = raw_answer[:text]
      answer.candidate ||= candidate_ids[raw_answer[:candidate_id].to_s]
      answer
    end
  end
end
