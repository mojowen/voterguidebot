class AddPublishedVersionToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :published_version, :string, default: 'unpublished'
    add_column :guides, :published_at, :timestamp
  end
end
