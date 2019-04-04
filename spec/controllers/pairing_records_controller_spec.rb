require 'rails_helper'

RSpec.describe PairingRecordsController, type: :controller do

  # TODO: Use FactoryGirl instead of instantiating every model manually

  before :all do
    @example_team = Team.create(name: 'Example Team')

    @john = Member.create(name: 'John', team_id: @example_team.id)
    @mary = Member.create(name: 'Mary', team_id: @example_team.id)
    @joseph = Member.create(name: 'Joseph', team_id: @example_team.id)
    @claudia = Member.create(name: 'Claudia', team_id: @example_team.id)

    @john_and_mary = PairingRecord.create(members: [@john, @mary])
  end

  describe "#create" do
    describe "returns bad request" do
      it "when team_id is missing" do
        post :create, params: { member_ids: [@john.id, @mary.id] }

        expect(response).to have_http_status(:bad_request)
      end

      it "when member_ids is missing" do
        post :create, params: { team_id: @example_team.id }

        expect(response).to have_http_status(:bad_request)
      end

      it "when member_ids length is not 2" do
        post :create, params: { team_id: @example_team.id, member_ids: [@john.id]}

        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "returns internal server error" do
      it "when there is a failure on pairing record creation" do
        allow(PairingRecord).to receive(:create).and_raise(StandardError)

        post :create, params: { team_id: @example_team.id, member_ids: [@john.id, @mary.id]}

        expect(response).to have_http_status(:internal_server_error)
      end
    end

    describe "returns created" do
      it "when everything is ok" do
        expect(PairingRecord).to receive(:create)
          .with(team_id: @example_team.id.to_s, member_ids: [@john.id.to_s, @mary.id.to_s])

        post :create, params: { team_id: @example_team.id, member_ids: [@john.id, @mary.id]}

        expect(response).to have_http_status(:created)
      end
    end
  end
end
