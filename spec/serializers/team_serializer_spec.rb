require 'rails_helper'

RSpec.describe TeamSerializer, type: :serializer do

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example', password: '123', password_confirmation: '123')

    john = Member.create(name: 'John', team_id: team.id)
    mary = Member.create(name: 'Mary', team_id: team.id)
    joseph = Member.create(name: 'Joseph', team_id: team.id)

    john_and_mary = PairingRecord.create(members: [john, mary], date: Date.today)

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
          date: Date.today,
          members: [
            { id: john.id, name: john.name },
            { id: mary.id, name: mary.name }
          ]
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
