class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    informed_name = params.require(:name),
    informed_password = params.require(:password)

    team = Team.where(name: informed_name).first

    if team&.authenticate(informed_password)
      jwt = { token: encode(team_id: team.id) }
      
      return render json: jwt, status: :created
    end

    head :unauthorized
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  private

  def encode(payload, expiration_time = 24.hours.from_now)
    payload[:expiration_time] = expiration_time.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s)
  end

  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end