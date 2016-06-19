class Measure < ActiveRecord::Base
  audited associated_with: :guide
  translates :title, :description, :yes_means, :no_means

  has_many :endorsements, as: :endorsing, dependent: :destroy
  belongs_to :guide
end
