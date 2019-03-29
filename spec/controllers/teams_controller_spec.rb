require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  describe "#create" do
    describe "returns bad request" do
      it "when name is missing" do
        @team = {
          members: ['John', 'Mary', 'Joseph', 'Claudia']
        }
      end

      it "when member list is missing" do
        @team = {
          name: 'Example team'
        }
      end

      it "when members length is less than 3" do
        @team = {
          name: 'Example team',
          members: ['John', 'Mary']
        }
      end

      after :each do
        post :create, params: @team

        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "returns internal server error" do
      before :each do
        @team = {
          name: 'Example Team',
          members: ['John', 'Mary', 'Joseph', 'Claudia']
        }
      end

      it "if there is a failure on team creation" do
        allow(Team).to receive(:create).and_raise(StandardError)
      end

      it "if there is a failure on any member creation" do
        allow(Member).to receive(:create).and_raise(StandardError)
      end

      after :each do
        post :create, params: @team

        expect(response).to have_http_status(:internal_server_error)
      end
    end

    it "returns created (and saves on database) if everything is ok" do
      request_body = {
        name: 'Example Team',
        members: ['John', 'Mary', 'Joseph', 'Claudia']
      }

      team_mock = Team.new
      team_mock.id = 123
      team_mock.name = 'Example Team'

      expect(Team)
        .to receive(:create)
        .with(name: 'Example Team')
        .and_return(team_mock)

      expect(Member).to receive(:create).with(name: 'John', team_id: 123)
      expect(Member).to receive(:create).with(name: 'Mary', team_id: 123)
      expect(Member).to receive(:create).with(name: 'Joseph', team_id: 123)
      expect(Member).to receive(:create).with(name: 'Claudia', team_id: 123)

      post :create, params: request_body

      expect(response).to have_http_status(:created)
    end
  end

end
