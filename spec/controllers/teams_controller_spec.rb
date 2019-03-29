require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  before :all do
    @john = Member.new
    @john.id = 1
    @john.name = 'John'

    @mary = Member.new
    @mary.id = 2
    @mary.name = 'Mary'

    @joseph = Member.new
    @joseph.id = 3
    @joseph.name = 'Joseph'

    @claudia = Member.new
    @claudia.id = 4
    @claudia.name = 'Claudia'

    @example_team = Team.new
    @example_team.id = 1
    @example_team.name = 'Example Team'
    @example_team.members = [ @john, @mary, @joseph, @claudia ]
  end

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

      expect(Team)
        .to receive(:create)
        .with(name: 'Example Team')
        .and_return(@example_team)

      expect(Member).to receive(:create).with(name: 'John', team_id: 1)
      expect(Member).to receive(:create).with(name: 'Mary', team_id: 1)
      expect(Member).to receive(:create).with(name: 'Joseph', team_id: 1)
      expect(Member).to receive(:create).with(name: 'Claudia', team_id: 1)

      post :create, params: request_body

      expect(response).to have_http_status(:created)
    end
  end

  describe "#show" do
    it "returns internal server error when a StandardError is thrown" do
      allow(Team).to receive(:find).and_raise(StandardError)

      get :show, params: { id: 1 }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns not found when there is no team with the informed id" do
      allow(Team).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get :show, params: { id: 'no team has this id' }

      expect(response).to have_http_status(:not_found)
    end

    it "returns ok and renders a team json when everything is ok" do
      allow(Team).to receive(:find).and_return(@example_team)

      get :show, params: { id: 1 }

      expected_response = {
        id: 1,
        name: 'Example Team',
        members: [
          { id: 1, name: 'John' },
          { id: 2, name: 'Mary' },
          { id: 3, name: 'Joseph' },
          { id: 4, name: 'Claudia' }
        ]
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response.to_json)
    end
  end
end
