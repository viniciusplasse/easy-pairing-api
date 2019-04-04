class TeamSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name

  has_many :members
  has_many :pairing_records

  def members
    object.members
  end

  def pairing_records
    distinct_pairing_records.flatten.compact
  end

  private

  def distinct_pairing_records
    @all_distinct_pairing_records = []

    members.map do |member|
      member.pairing_records.map do |pairing_record|
        next if already_included? pairing_record
        @all_distinct_pairing_records << pairing_record

        PairingRecordSerializer.new(pairing_record)
      end
    end
  end

  def already_included?(pairing_record)
    @all_distinct_pairing_records.select do |unique_record|
      unique_record.id == pairing_record.id
    end.length > 0
  end
end
