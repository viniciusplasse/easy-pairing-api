require 'rails_helper'

RSpec.describe PairingSuggestionsController, type: :controller do

  let(:pairing_suggest) { double }
  let(:pairing_suggestions) { 
    {
      members: [
        { id: 10, name: 'john' },
        { id: 20, name: 'joseph' }
      ] 
    }
  }

  describe "#show" do
    it "returns a pairing suggestion with the members who paired the least" do
      allow(PairingSuggest).to receive(:new).with('1')
        .and_return(pairing_suggest)
  
      allow(pairing_suggest).to receive(:get_pair_suggestions)
        .and_return(pairing_suggestions)

      get :show, params: { id: 1 }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(pairing_suggestions.to_json)
    end
  end
end
