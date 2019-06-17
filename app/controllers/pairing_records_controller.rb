class PairingRecordsController < ApplicationController
  before_action :verify_authorization_header unless Rails.env.test?
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
      Rails.logger.info('Error adding pairing record: ' + e.inspect)
      return head :internal_server_error
    end

    head :created
  end

  def destroy
    pairing_record_id = params[:id]

    begin
      PairingRecord.destroy(pairing_record_id)
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_server_error
    end

    head :ok
  end
end
