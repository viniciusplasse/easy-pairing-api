class AddMemberIdsToPairs < ActiveRecord::Migration[5.2]
  def change
    change_table :pairs do |t|
      t.references :member
      t.references :other_member
    end
  end
end
