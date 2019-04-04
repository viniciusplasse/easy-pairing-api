class PairingRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    team_id = params[:team_id]
    member_ids = params[:member_ids]

    if team_id.nil? || member_ids.nil? || member_ids.length != 2
      return head :bad_request
    end

    begin
      PairingRecord.create(team_id: team_id, member_ids: member_ids)
    rescue StandardError
      return head :internal_server_error
    end

    head :created
  end
end
