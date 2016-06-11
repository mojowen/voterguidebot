class AddElectionDateToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :election_date, :date
  end
end
