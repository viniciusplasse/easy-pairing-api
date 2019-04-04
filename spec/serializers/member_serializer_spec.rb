require 'rails_helper'

RSpec.describe MemberSerializer, type: :serializer do

  it 'returns serialized info' do
    team = Team.create(id: 1, name: 'Example')
    member = Member.create(id: 1, name: 'John', team_id: team.id)

    expected_serialized_member = { id: 1, name: 'John' }

    expect(MemberSerializer.new(member).to_json).to eq(expected_serialized_member.to_json)

    # TODO: Mock db interactions in order to stop using #destroy

    member.destroy
    team.destroy
  end
end
