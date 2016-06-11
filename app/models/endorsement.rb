class Endorsement < ActiveRecord::Base
  audited associated_with: :guide

  translates :endorser
  belongs_to :candidate
  has_one :guide, through: :candidate
end
