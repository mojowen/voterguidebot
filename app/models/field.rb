class Field < ActiveRecord::Base
  audited associated_with: :guide
  translates :value

  attr_accessor :limit

  belongs_to :guide
  delegate :template, to: :guide
end
