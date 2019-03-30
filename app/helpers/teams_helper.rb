module TeamsHelper
  def generate_distinct_pairing_records(members)
    distinct_pairing_records = []

    (0...members.length).each do |i|
      ((i + 1)...members.length).each do |j|
        unique_pair = { members: [members[i], members[j]] }

        distinct_pairing_records << PairingRecord.create(unique_pair)
      end
    end

    distinct_pairing_records
  end
end
