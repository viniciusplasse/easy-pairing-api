class ChangeNullableDateToNotNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :pairing_records, :date, false
  end
end
