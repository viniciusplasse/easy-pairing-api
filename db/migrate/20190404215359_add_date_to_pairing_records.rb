class AddDateToPairingRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :pairing_records, :date, :date
  end
end
