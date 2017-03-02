class Candidate < ActiveRecord::Base
  audited associated_with: :guide

  translates :bio
  belongs_to :contest
  has_one :guide, through: :contest

  has_many :answers, dependent: :destroy
  include Endorsements

  def assign_attributes(attributes)
    create_endorsements!(attributes)
    super(attributes)
  end

  def slug
    (name || "#{id}").gsub(/\s/, '-').downcase.gsub(/[^\w-]/, '')
  end
end
