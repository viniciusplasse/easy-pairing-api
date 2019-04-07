class AddIndexToMembers < ActiveRecord::Migration[5.2]
  def change
    add_index :members, [:name, :team_id], unique: true
  end
end
