class Endorsement < ActiveRecord::Base
  audited associated_with: :candidate

  translates :endorser
  belongs_to :candidate
end
