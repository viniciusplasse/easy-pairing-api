class RemoveOtherMemberIdFromPairingRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :pairing_records, :other_member_id, :bigint
  end
end
