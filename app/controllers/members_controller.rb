class MembersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    team_id = params[:id]
    name = params[:name]

    if name.nil?
      return head :bad_request
    end

    begin
      Member.create(name: name, team_id: team_id)
    rescue ActiveRecord::RecordNotUnique
      return head :bad_request
    rescue StandardError
      return head :internal_server_error
    end

    head :created
  end

  def destroy
    member_id = params[:id]

    begin
      Member.destroy(member_id)
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_sever_error
    end

    head :ok
  end
end
