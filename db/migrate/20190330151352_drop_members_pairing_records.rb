class DropMembersPairingRecords < ActiveRecord::Migration[5.2]
  def change
    drop_table :members_pairing_records
  end
end
