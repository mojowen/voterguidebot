module Endorsements
  extend ActiveSupport::Concern

  included do
    has_many :endorsements, as: :endorsed, dependent: :destroy, autosave: true
  end

  private

  def create_endorsements!(associates_obj)
    return unless associates_obj[:endorsements]
    associates_obj[:endorsements].map! do |raw_endorsement|
      endorsements.find_or_initialize_by(
        stance: raw_endorsement[:stance] || 0,
        endorser: raw_endorsement[:endorser])
    end
  end

end
