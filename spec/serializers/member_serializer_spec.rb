require 'rails_helper'

RSpec.describe MemberSerializer, type: :serializer do

  # TODO: Mock db interactions

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example')
    member = Member.create(id: 1, name: 'John', team_id: team.id)

    expected_serialized_member = { id: 1, name: 'John' }

    expect(MemberSerializer.new(member).to_json).to eq(expected_serialized_member.to_json)
  end
end
