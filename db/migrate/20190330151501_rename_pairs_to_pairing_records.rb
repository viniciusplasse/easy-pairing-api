class RenamePairsToPairingRecords < ActiveRecord::Migration[5.2]
  def change
    rename_table :pairs, :pairing_records
  end
end
