class AddRecommendationToBallotMeasure < ActiveRecord::Migration
  def change
    add_column :measures, :stance, :integer
  end
end
