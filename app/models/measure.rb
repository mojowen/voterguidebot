class Measure < ActiveRecord::Base
  audited associated_with: :guide
  translates :title, :description, :yes_means, :no_means

  include Endorsements
  include Tags
  include Stance

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

  def full_clone
    cloned = dup
    cloned.endorsements = endorsements.map(&:dup)
    cloned.tags = tags.map(&:dup)
    cloned
  end

  def slug
    title.gsub(/\s/, '-').downcase.gsub(/[^\w-]/, '')
  end
end
