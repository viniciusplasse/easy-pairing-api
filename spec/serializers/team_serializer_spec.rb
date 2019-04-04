require 'rails_helper'

RSpec.describe TeamSerializer, type: :serializer do

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example')

    john = Member.create(name: 'John', team_id: team.id)
    mary = Member.create(name: 'Mary', team_id: team.id)
    joseph = Member.create(name: 'Joseph', team_id: team.id)

    john_and_mary = PairingRecord.create(members: [john, mary])

    expected_serialized_team = {
      id: 1,
      name: 'Example',
      members: [
        { id: john.id, name: john.name },
        { id: mary.id, name: mary.name },
        { id: joseph.id, name: joseph.name }
      ],
      pairing_records: [
        {
          id: john_and_mary.id,
          members: [
            { id: john.id, name: john.name },
            { id: mary.id, name: mary.name }
          ],
          date: Date.today
        }
      ]
    }

    expect(TeamSerializer.new(team).pairing_records.to_json).to eq(expected_serialized_team[:pairing_records].to_json)
    expect(TeamSerializer.new(team).to_json).to eq(expected_serialized_team.to_json)

    # TODO: Mock db interactions in order to stop using #destroy

    john.destroy
    mary.destroy
    joseph.destroy
    team.destroy
    john_and_mary.destroy
  end
end
