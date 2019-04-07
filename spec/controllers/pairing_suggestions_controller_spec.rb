require 'rails_helper'

RSpec.describe PairingSuggestionsController, type: :controller do

  describe "#show" do
    it "returns a pairing suggestion with the members who paired the least" do
      team = Team.create(name: 'Example')

      john = Member.create(name: 'John', team_id: team.id)
      mary = Member.create(name: 'Mary', team_id: team.id)
      joseph = Member.create(name: 'Joseph', team_id: team.id)
      claudia = Member.create(name: 'Claudia', team_id: team.id)

      john_and_mary = PairingRecord.create(date: Date.yesterday, members: [john, mary])
      joseph_and_claudia = PairingRecord.create(date: Date.yesterday, members: [joseph, claudia])

      get :show, params: { id: team.id }

      expected_response = {
        members: [
          { id: john.id, name: john.name },
          { id: joseph.id, name: joseph.name }
        ]
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response.to_json)

      john.destroy
      mary.destroy
      joseph.destroy
      claudia.destroy
      john_and_mary.destroy
      joseph_and_claudia.destroy
      team.destroy
    end
  end
end
