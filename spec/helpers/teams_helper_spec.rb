require 'rails_helper'

RSpec.describe TeamsHelper, type: :helper do

  # TODO: Use FactoryGirl instead of instantiating every model manually

  describe "#generate_distinct_pairing_records" do
    it "receives a member list and returns distinct pairing records instances" do
      john = Member.new
      john.id = 1
      john.name = 'John'

      mary = Member.new
      mary.id = 2
      mary.name = 'Mary'

      joseph = Member.new
      joseph.id = 3
      joseph.name = 'Joseph'

      example_team = Team.new
      example_team.id = 1
      example_team.name = 'Example Team'
      example_team.members = [john, mary, joseph]

      john_and_mary = PairingRecord.new
      john_and_mary.id = 1
      john_and_mary.members = [john, mary]

      john_and_joseph = PairingRecord.new
      john_and_joseph.id = 2
      john_and_joseph.members = [john, joseph]

      mary_and_joseph = PairingRecord.new
      mary_and_joseph.id = 3
      mary_and_joseph.members = [mary, joseph]

      allow(PairingRecord).to receive(:create)
                          .with(hash_including(members: john_and_mary.members))
                          .and_return(john_and_mary)

      allow(PairingRecord).to receive(:create)
                          .with(hash_including(members: john_and_joseph.members))
                          .and_return(john_and_joseph)

      allow(PairingRecord).to receive(:create)
                          .with(hash_including(members: mary_and_joseph.members))
                          .and_return(mary_and_joseph)

      actual_pairing_records = generate_distinct_pairing_records(example_team.members)
      expected_pairing_records = [john_and_mary, john_and_joseph, mary_and_joseph]

      expect(actual_pairing_records).to eq(expected_pairing_records)
    end
  end
end
