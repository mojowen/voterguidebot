class AddActiveFlagToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :active, :boolean, default: true
  end
end
