class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    team_name = params[:name]
    team_members = params[:members]

    if team_name.nil? || team_members.nil? || team_members.length < 3
      return head :bad_request
    end

    begin
      team = Team.create(name: team_name)
      team_members.each do |member|
        Member.create(name: member, team_id: team.id)
      end
    rescue StandardError
      return head :internal_server_error
    end

    head :created
  end

  def show
    team_id = params[:id]

    begin
      team = Team.find(team_id)

      response_payload = {
        id: team.id,
        name: team.name,
        members: team.members.map do |member|
          {
            id: member.id,
            name: member.name
          }
        end
      }

      render json: response_payload, status: :ok
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_server_error
    end
  end
end
