require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  before :all do
    @example_team = Team.create(name: 'Example Team', password: '123', password_confirmation: '123')

    @john = Member.create(name: 'John', team_id: @example_team.id)
    @mary = Member.create(name: 'Mary', team_id: @example_team.id)
    @joseph = Member.create(name: 'Joseph', team_id: @example_team.id)
    @claudia = Member.create(name: 'Claudia', team_id: @example_team.id)

    @john_and_mary = PairingRecord.create(members: [@john, @mary], date: Date.today)
  end

  describe "#create" do
    describe "returns bad request" do
      it "when name is missing" do
        @team = {
          members: ['John', 'Mary', 'Joseph', 'Claudia'],
          password: '123',
          password_confirmation: '123'
        }
      end

      it "when member list is missing" do
        @team = {
          name: 'Example team',
          password: '123',
          password_confirmation: '123'
        }
      end

      it "when members length is less than 3" do
        @team = {
          name: 'Example team',
          members: ['John', 'Mary'],
          password: '123',
          password_confirmation: '123'
        }
      end
     
      it "when password is empty" do
        @team = {
          name: 'Example team',
          members: ['John', 'Mary', 'Claudia'],
          password: '',
          password_confirmation: ''
        }
      end

      it "when passwords do not match" do
        @team = {
          name: 'Example team',
          members: ['John', 'Mary', 'Claudia'],
          password: 'what the hell',
          password_confirmation: 'what the hell but different'
        }
      end

      it "when team name already exists" do
        @team = {
          name: 'Example Team',
          members: ['John', 'Mary', 'Claudia'],
          password: 'Password',
          password_confirmation: 'Password'
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
          name: 'Perfect Team',
          members: ['John', 'Mary', 'Joseph', 'Claudia'],
          password: '123',
          password_confirmation: '123'
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
        name: 'Perfect Team',
        members: ['John', 'Mary', 'Joseph', 'Claudia'],
        password: '123',
        password_confirmation: '123'
      }

      expect(Team).to receive(:create)
        .with(hash_including(name: 'Perfect Team', password: '123', password_confirmation: '123'))
        .and_call_original

      expect(Member).to receive(:create).with(hash_including(name: 'John')).and_call_original
      expect(Member).to receive(:create).with(hash_including(name: 'Mary')).and_call_original
      expect(Member).to receive(:create).with(hash_including(name: 'Joseph')).and_call_original
      expect(Member).to receive(:create).with(hash_including(name: 'Claudia')).and_call_original

      post :create, params: request_body

      expect(response).to have_http_status(:created)
    end
  end

  describe "#show" do
    it "returns internal server error when a StandardError is thrown" do
      allow(Team).to receive(:find).and_raise(StandardError)

      get :show, params: { id: @example_team.id }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns not found when there is no team with the informed id" do
      allow(Team).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get :show, params: { id: 'no team has this id' }

      expect(response).to have_http_status(:not_found)
    end

    it "returns ok and renders a team json when everything is ok" do
      get :show, params: { id: @example_team.id }

      expected_response = {
        id: @example_team.id,
        name: @example_team.name,
        members: [
          { id: @john.id, name: @john.name },
          { id: @mary.id, name: @mary.name },
          { id: @joseph.id, name: @joseph.name },
          { id: @claudia.id, name: @claudia.name }
        ],
        pairing_records: [
          {
            id: @john_and_mary.id,
            date: Date.today,
            members: [
              { id: @john.id, name: @john.name },
              { id: @mary.id, name: @mary.name }
            ]
          }
        ]
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  # TODO: Mock db interactions in order to stop using #destroy

  after :all do
    @john.destroy
    @mary.destroy
    @joseph.destroy
    @claudia.destroy
    @example_team.destroy
    @john_and_mary.destroy
  end
end
