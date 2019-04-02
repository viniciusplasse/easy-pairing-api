require 'rails_helper'

RSpec.describe TeamSerializer, type: :serializer do

  # TODO: Mock db interactions

  it 'returns serialized info' do
    john = Member.create(id: 1, name: 'John')
    mary = Member.create(id: 2, name: 'Mary')
    joseph = Member.create(id: 3, name: 'Joseph')

    team = Team.create(id: 1, name: 'Example', members: [john, mary, joseph])

    expected_serialized_team = {
        id: 1,
        name: 'Example',
        members: [
          { id: 1, name: 'John' },
          { id: 2, name: 'Mary' },
          { id: 3, name: 'Joseph' }
        ]
    }

    expect(TeamSerializer.new(team).to_json).to eq(expected_serialized_team.to_json)
  end
end
