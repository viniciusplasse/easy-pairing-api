class Member < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :pairing_records

  def get_pairing_occurrences_with(member)
    pairing_records.count { |record| record.members.include?(member) }
  end
end
