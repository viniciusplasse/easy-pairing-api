class MembersController < ApplicationController
  before_action :verify_authorization_header unless Rails.env.test?
  skip_before_action :verify_authenticity_token

  def create
    team_id = params[:id]
    name = params[:name]

    return head :bad_request if name.nil?

    begin
      Member.create(name: name, team_id: team_id)
    rescue ActiveRecord::RecordNotUnique
      return head :bad_request
    rescue StandardError
      return head :internal_server_error
    end

    head :created
  end

  def update
    member_id = params[:id]
    new_name = params[:name]

    return head :bad_request if new_name.nil?

    begin
      Member.find(member_id).update_attributes(name: new_name)
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_server_error
    end

    head :ok
  end

  def destroy
    member_id = params[:id]

    begin
      member = Member.find(member_id)
      member.pairing_record_ids.each do |record_id|
        PairingRecord.find(record_id).destroy
      end
      member.destroy
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    end

    head :ok
  end
end
