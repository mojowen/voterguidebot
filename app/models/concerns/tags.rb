module Tags
  extend ActiveSupport::Concern

  included do
    has_many :tags, as: :tagged, dependent: :destroy, autosave: true
  end

  private

  def create_tags!(associates_obj)
    return unless associates_obj[:tags]
    associates_obj[:tags].map! do |raw_tag|
      tags.find_or_initialize_by(
        name: raw_tag[:name])
    end
  end
end
