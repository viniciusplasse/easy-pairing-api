require 'rails_helper'

RSpec.describe MembersController, type: :controller do
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
