require 'rails_helper'

RSpec.describe PairingRecordsController, type: :controller do

  before :each do
    @example_team = Team.create(name: 'Example Team', password: '123', password_confirmation: '123')

    @john = Member.create(name: 'John', team_id: @example_team.id)
    @mary = Member.create(name: 'Mary', team_id: @example_team.id)
    @joseph = Member.create(name: 'Joseph', team_id: @example_team.id)
    @claudia = Member.create(name: 'Claudia', team_id: @example_team.id)

    @john_and_mary = PairingRecord.create(members: [@john, @mary], date: Date.today)
  end

  describe "#create" do
    describe "returns bad request" do
      it "when date is missing" do
        post :create, params: { member_ids: [@john.id, @mary.id] }

        expect(response).to have_http_status(:bad_request)
      end

      it "when member_ids is missing" do
        post :create, params: { date: Date.today }

        expect(response).to have_http_status(:bad_request)
      end

      it "when member_ids length is not 2" do
        post :create, params: { member_ids: [@john.id], date: Date.today }

        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "returns internal server error" do
      it "when there is a failure on pairing record creation" do
        allow(PairingRecord).to receive(:create).and_raise(StandardError)

        post :create, params: { member_ids: [@john.id, @mary.id], date: Date.today }

        expect(response).to have_http_status(:internal_server_error)
      end
    end

    describe "returns created" do
      it "when everything is ok" do
        formatted_today_date = DateTime.strptime(Date.today.to_s, '%Y-%m-%d')

        expect(PairingRecord).to receive(:create)
          .with(member_ids: [@john.id.to_s, @mary.id.to_s], date: formatted_today_date)

        post :create, params: { member_ids: [@john.id, @mary.id], date: Date.today.to_s }

        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "#destroy" do
    it "returns not found if there is no team with the id informed" do
      allow(PairingRecord).to receive(:destroy).and_raise(ActiveRecord::RecordNotFound)

      delete :destroy, params: { id: 'non existent team id' }

      expect(response).to have_http_status(:not_found)
    end

    it "returns internal server error if there is a failure on pairing record deletion" do
      allow(PairingRecord).to receive(:destroy).and_raise(StandardError)

      delete :destroy, params: { id: @john_and_mary.id }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns ok if there pairing record was deleted successfully" do
      delete :destroy, params: { id: @john_and_mary.id }

      expect(response).to have_http_status(:ok)
    end
  end

  # TODO: Mock db interactions in order to stop using #destroy

  after :each do
    @john.destroy
    @mary.destroy
    @joseph.destroy
    @claudia.destroy
    @example_team.destroy
    @john_and_mary.destroy
  end
end
