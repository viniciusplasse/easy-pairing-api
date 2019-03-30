class CreateJoinTableMemberPairingRecord < ActiveRecord::Migration[5.2]
  def change
    create_join_table :members, :pairing_records do |t|
      t.index [:member_id, :pairing_record_id], unique: true, name: 'index_members_records'
    end
  end
end
