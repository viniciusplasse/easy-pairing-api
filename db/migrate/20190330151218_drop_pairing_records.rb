class DropPairingRecords < ActiveRecord::Migration[5.2]
  def change
    drop_table :pairing_records
  end
end
