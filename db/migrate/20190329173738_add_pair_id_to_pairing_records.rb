class AddPairIdToPairingRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :pairing_records, :pair, foreign_key: true
  end
end
