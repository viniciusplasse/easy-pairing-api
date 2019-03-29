class CreatePairs < ActiveRecord::Migration[5.2]
  def change
    create_table :pairs do |t|

      t.timestamps
    end
  end
end
