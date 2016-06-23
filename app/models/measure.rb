class Measure < ActiveRecord::Base
  audited associated_with: :guide
  translates :title, :description, :yes_means, :no_means

  has_many :endorsements, as: :endorsing, dependent: :destroy
  belongs_to :guide

  def as_json(options = nil)
    super({ include: :endorsements }.update(options))
  end

  def assign_attributes(attributes)
    @associates_obj = attributes
    create_endorsements!
    super(associates_obj)
  end

  private

  def create_endorsements!
    return unless associates_obj[:endorsements]
    associates_obj[:endorsements].map! do |raw_endorsement|
      endorsements.find_or_initialize_by(
        stance: raw_endorsement[:stance],
        endorser: raw_endorsement[:endorser])
    end
  end


  attr_accessor :associates_obj

end
