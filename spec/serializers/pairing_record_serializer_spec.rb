require 'rails_helper'

RSpec.describe PairingRecordSerializer, type: :serializer do

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example')
    john = Member.create(id: 1, name: 'John', team_id: team.id)
    mary = Member.create(id: 2, name: 'Mary', team_id: team.id)

    john_and_mary = PairingRecord.create(id: 1, members: [john, mary], date: Date.today)

    serialized_pairing_record = {
      id: john_and_mary.id,
      date: Date.today,
      members: [
        { id: john.id, name: john.name },
        { id: mary.id, name: mary.name }
      ]
    }

    expect(PairingRecordSerializer.new(john_and_mary).to_json).to eq(serialized_pairing_record.to_json)

    # TODO: Mock db interactions in order to stop using #destroy

    john.destroy
    mary.destroy
    team.destroy
    john_and_mary.destroy
  end
end
