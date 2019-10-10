require 'rails_helper'

RSpec.describe PairingSuggest do
  before :each do
    @team = Team.create(name: 'Example', password: '123', password_confirmation: '123')

    @john = Member.create(name: 'John', team_id: @team.id)
    @mary = Member.create(name: 'Mary', team_id: @team.id)
    @joseph = Member.create(name: 'Joseph', team_id: @team.id)
    @claudia = Member.create(name: 'Claudia', team_id: @team.id)

    @john_and_mary = PairingRecord.create(date: Date.yesterday, members: [@john, @mary])
    @joseph_and_claudia = PairingRecord.create(date: Date.yesterday, members: [@joseph, @claudia])
  end

  describe "#get_pair_suggestions" do
    it "returns a pairing suggestion with the members who paired the least" do
      expected_pairs = {
        members: [
          { id: @john.id, name: @john.name },
          { id: @joseph.id, name: @joseph.name }
        ]
      }

      pairs = PairingSuggest.new(@team.id).get_pair_suggestions

      expect(pairs).to eq(expected_pairs)
    end
  end

  after :each do
    @john.destroy
    @mary.destroy
    @joseph.destroy
    @claudia.destroy
    @john_and_mary.destroy
    @joseph_and_claudia.destroy
    @team.destroy
  end
end