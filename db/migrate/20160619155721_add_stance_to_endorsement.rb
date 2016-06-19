class AddStanceToEndorsement < ActiveRecord::Migration
  def change
    add_column :endorsements, :stance, :integer, default: 0, index: true
  end
end
