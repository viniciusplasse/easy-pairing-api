class RemoveMemberIdFromPairingRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :pairing_records, :member_id, :bigint
  end
end
