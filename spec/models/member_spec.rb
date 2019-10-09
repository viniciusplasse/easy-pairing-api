require 'rails_helper'

RSpec.describe Member do
  before :each do
    @example_team = Team.create(name: 'Example Team', password: '123', password_confirmation: '123')
    @john = Member.create(name: 'John', team_id: @example_team.id)
    @angela = Member.create(name: 'Angela', team_id: @example_team.id)
  end  

  describe 'get_pairing_occurrences_with' do
    it 'returns 0 if has no occurences' do
      pairing_occurences = @john.get_pairing_occurrences_with(@angela)

      expect(pairing_occurences).to be(0)
    end

    it 'returns 2 ocurrences' do
      PairingRecord.create(members: [@john, @angela], date: Date.yesterday)
      PairingRecord.create(members: [@john, @angela], date: Date.today)

      pairing_occurences = @john.get_pairing_occurrences_with(@angela)

      expect(pairing_occurences).to be(2)
    end
  end

  after :each do
    @john.destroy
    @angela.destroy
    @example_team.destroy
  end 
end