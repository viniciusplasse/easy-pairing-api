require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include AuthenticationHelper

  describe "#verify_authorization_header" do
    it "returns the decoded JWT informed in Authorization header" do
      team = Team.create(name: 'Example',
                         password: '123',
                         password_confirmation: '123')

      allow_any_instance_of(ActionController::TestRequest)
        .to receive(:headers)
        .and_return({ 'Authorization' => encode(team_id: team.id) })

      expect(controller.send(:verify_authorization_header)['team_id']).to eq(team.id)

      team.destroy
    end
  end
end
