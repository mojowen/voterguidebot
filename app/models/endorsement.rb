class Endorsement < ActiveRecord::Base
  translates :endorser
  belongs_to :candidate
end
