class Measure < ActiveRecord::Base
  audited associated_with: :guide
  translates :title, :description, :yes_means, :no_means

  include Endorsements

  belongs_to :guide

  def as_json(options = nil)
    super({ include: :endorsements }.update(options))
  end

  def assign_attributes(attributes)
    create_endorsements!(attributes)
    super(attributes)
  end
end
