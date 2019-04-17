require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe "#create" do
    it "returns bad request if name is missing" do
      post :create, params: { id: 1 }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns bad request if member name is not unique in a team" do
      allow(Member).to receive(:create).and_raise(ActiveRecord::RecordNotUnique)

      post :create, params: { id: 1, name: 'not unique member name' }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns internal server error when a StandardError is thrown" do
      allow(Member).to receive(:create).and_raise(StandardError)

      get :create, params: { id: 1, name: 'Ricky' }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns created (and saves on database) if everything is ok" do
      allow(Member).to receive(:create)
      expect(Member).to receive(:create).with(hash_including(name: 'Ricky'))

      post :create, params: { id: 1, name: 'Ricky' }

      expect(response).to have_http_status(:created)
    end
  end

  describe "#update" do
    it "returns bad request if name is missing" do
      put :update, params: { id: 1 }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns not found if there is no member with the id informed" do
      allow(Member).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      put :update, params: { id: 'non existent member id', name: 'Ricky Renamed' }

      expect(response).to have_http_status(:not_found)
    end

    it "returns internal server error if there is a failure on member update" do
      allow_any_instance_of(Member)
          .to receive(:update_attributes)
                  .and_raise(ActiveModel::UnknownAttributeError)

      team = Team.create(name: 'BuFangLaJiao', password: '123', password_confirmation: '123')
      ricky = Member.create(name: "Ricky", team_id: team.id)

      put :update, params: { id: ricky.id, name: 'Ricky Renamed' }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns ok if member was edited successfully" do
      expect_any_instance_of(Member)
          .to receive(:update_attributes)
                  .with(hash_including({ name: 'Ricky Renamed' }))

      team = Team.create(name: 'BuFangLaJiao', password: '123', password_confirmation: '123')
      ricky = Member.create(name: "Ricky", team_id: team.id)

      put :update, params: { id: ricky.id, name: 'Ricky Renamed' }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "#destroy" do
    it "returns not found if there is no member with the id informed" do
      allow(Member).to receive(:destroy).and_raise(ActiveRecord::RecordNotFound)

      delete :destroy, params: { id: 'non existent team id' }

      expect(response).to have_http_status(:not_found)
    end

    it "returns internal server error if there is a failure on member deletion" do
      allow(Member).to receive(:destroy).and_raise(StandardError)

      delete :destroy, params: { id: 1 }

      expect(response).to have_http_status(:internal_server_error)
    end

    it "returns ok if there member was deleted successfully" do
      allow(Member).to receive(:destroy)

      expect(Member).to receive(:destroy).with("1")

      delete :destroy, params: { id: 1 }

      expect(response).to have_http_status(:ok)
    end
  end
end
