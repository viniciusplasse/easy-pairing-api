require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe "#create" do
    describe "returns bad request" do
      it "when the team's name is missing" do
        request_body = { password: 'Password' }

        post :create, params: request_body

        expect(response).to have_http_status(:bad_request)
      end

      it "when the team's password is missing" do
        request_body = { name: 'A team\'s name' }

        post :create, params: request_body

        expect(response).to have_http_status(:bad_request)
      end
    end

    it "returns unauthorized when login is invalid" do
      request_body = { name: 'Example', password: 'Wrong password' }

      post :create, params: request_body

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a token with http status 201 when login is valid" do
      team = Team.create(name: 'Example',
                         password: '123',
                         password_confirmation: '123')

      request_body = { name: 'Example', password: '123' }

      post :create, params: request_body

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['team_id']).to eq(team.id)
      expect(JSON.parse(response.body)['token']).to match(/eyJhbGciOiJIUzI1NiJ9.*/)


      team.destroy
    end
  end
end
