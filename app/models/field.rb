class Field < ActiveRecord::Base
  audited associated_with: :guide

  belongs_to :guide
  delegate :template, to: :guide
end
