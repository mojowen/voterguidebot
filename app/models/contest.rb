class Contest < ActiveRecord::Base
  audited associated_with: :guide
  has_associated_audits

  translates :description, :title

  belongs_to :guide
  has_many :candidates
  has_many :questions
  has_many :answers, through: :questions
  has_many :endorsements, through: :candidates

  def assign_associates(associates_obj)
    @associates_obj = associates_obj.with_indifferent_access
    assign_association! :candidates
    assign_association! :questions
    create_endorsements!
    create_answers!
  end

  def as_json(options = nil)
    super({
      include: { candidates: { include: :endorsements },
                 questions: { include: :answers }}
      }.update(options))
  end

  private

  attr_accessor :associates_obj

  def assign_association!(association)
    return unless associates_obj[association]

    associates_obj[association].each do |raw_obj|
      raw_id = raw_obj.delete :id
      activerec_obj = send(association).find_by id: raw_id

      if raw_obj.key? :_destroy
        activerec_obj.destroy
      else
        if activerec_obj
          activerec_obj.update_attributes raw_obj
        else
          activerec_obj = send(association).create! raw_obj
          reassign_ids association, raw_id, activerec_obj.id
        end
        raw_obj[:id] = activerec_obj.id
      end
    end
  end

  def reassign_ids(association, old_id, new_id)
    as_key = "#{association.to_s.singularize}_id"

    %w{answers endorsements}.each do |sub_association|
      next unless associates_obj[sub_association]
      associates_obj[sub_association].map! do |sub_obj|
        foreign_key = sub_association == 'endorsements' ? :endorsing_id : as_key
        sub_obj.update({ foreign_key => new_id }) if sub_obj[foreign_key] == old_id
      end
    end
  end

  def create_endorsements!
    return unless associates_obj[:endorsements]
    saved_endorsements = []

    associates_obj[:endorsements].each do |raw_endorsement|
      endorsement = endorsements.find_or_initialize_by(
        endorsing_id: raw_endorsement[:endorsing_id],
        endorsing_type: raw_endorsement[:endorsing_type])

      endorsement.endorser = raw_endorsement[:endorser]
      next unless endorsement.valid?
      endorsement.save
      saved_endorsements.push(endorsement.id)
    end

    endorsements.each do |endorsement|
      endorsement.destroy unless saved_endorsements.include? endorsement.id
    end
  end

  def create_answers!
    return unless associates_obj[:answers]
    saved_answers = []

    associates_obj[:answers].each do |raw_answer|
      answer = answers.find_or_initialize_by(
        candidate_id: raw_answer[:candidate_id],
        question_id: raw_answer[:question_id])

      answer.text = raw_answer[:text]
      next unless answer.valid?
      answer.save
      saved_answers.push(answer.id)
    end

    answers.reject{ |answer| saved_answers.include? answer.id }.each(&:destroy)
  end
end
