class AddGuideToUpload < ActiveRecord::Migration
  def change
    add_reference :uploads, :guide, index: true
  end
end
