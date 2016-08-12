class Endorsement < ActiveRecord::Base
  include Stance
  audited associated_with: :guide

  translates :endorser
  belongs_to :endorsed, polymorphic: true

  def guide
    endorsed.try(:guide)
  end
end
