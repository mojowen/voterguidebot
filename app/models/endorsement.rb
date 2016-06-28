class Endorsement < ActiveRecord::Base
  audited associated_with: :guide

  translates :endorser
  belongs_to :endorsed, polymorphic: true

  enum stance: %w{for against}

  def guide
    endorsed.try(:guide)
  end
end
