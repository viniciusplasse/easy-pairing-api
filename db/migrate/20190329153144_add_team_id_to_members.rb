class AddTeamIdToMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :team, foreign_key: true
  end
end
