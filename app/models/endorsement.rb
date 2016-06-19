class Endorsement < ActiveRecord::Base
  audited associated_with: :guide

  translates :endorser
  belongs_to :endorsing, polymorphic: true

  enum stance: %w{for against}

  def guide
    endorsing.try(:guide)
  end

end
