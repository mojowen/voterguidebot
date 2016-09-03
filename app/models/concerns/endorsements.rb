module Endorsements
  extend ActiveSupport::Concern

  included do
    has_many :endorsements, -> { order(position: :asc) }, as: :endorsed, dependent: :destroy, autosave: true
  end

  private

  def create_endorsements!(associates_obj)
    if associates_obj[:endorsements]
      associates_obj[:endorsements].map!.with_index do |raw_endorsement, index|
        endorsement = endorsements.find_or_initialize_by(
          stance: raw_endorsement[:stance] || 0,
          endorser: raw_endorsement[:endorser])
        endorsement.position = index
        endorsement
      end
    else
      associates_obj[:endorsements] = []
    end
  end

end
