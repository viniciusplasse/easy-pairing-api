require 'rails_helper'

RSpec.describe PairingRecordSerializer, type: :serializer do

  # TODO: Mock db interactions

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example')
    john = Member.create(id: 1, name: 'John', team_id: team.id)
    mary = Member.create(id: 2, name: 'Mary', team_id: team.id)

    john_and_mary = PairingRecord.create(id: 1, members: [john, mary])

    serialized_pairing_record = {
      id: john_and_mary.id,
      members: [
        { id: john.id, name: john.name },
        { id: mary.id, name: mary.name }
      ]
    }

    expect(PairingRecordSerializer.new(john_and_mary).to_json).to eq(serialized_pairing_record.to_json)
  end
end
