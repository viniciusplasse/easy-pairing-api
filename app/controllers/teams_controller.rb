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
end
