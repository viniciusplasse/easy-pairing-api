class PairingRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    member_ids = params[:member_ids]
    date = params[:date]

    if member_ids.nil? || member_ids.length != 2 || date.nil?
      return head :bad_request
    end

    begin
      PairingRecord.create(member_ids: member_ids, date: date)
    rescue StandardError => e
      Rails.logger.info(e.message.to_s)
      return head :internal_server_error
    end

    head :created
  end
end
