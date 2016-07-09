class Measure < ActiveRecord::Base
  audited associated_with: :guide
  translates :title, :description, :yes_means, :no_means

  include Endorsements
  include Tags

  belongs_to :guide
  delegate :template, to: :guide

  def as_json(options = nil)
    super({ include: [:endorsements, :tags], methods: :template }.update(options))
  end

  def assign_attributes(attributes)
    create_endorsements! attributes
    create_tags! attributes
    super(attributes)
  end
end
