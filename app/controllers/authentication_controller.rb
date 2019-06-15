class AuthenticationController < ApplicationController
  include AuthenticationHelper

  skip_before_action :verify_authenticity_token

  def create
    informed_name = params.require(:name),
    informed_password = params.require(:password)

    team = Team.where(name: informed_name).first

    if team&.authenticate(informed_password)
      jwt = { token: encode(team_id: team.id), team_id: team.id }

      return render json: jwt, status: :created
    end

    head :unauthorized
  rescue ActionController::ParameterMissing
    head :bad_request
  end
end