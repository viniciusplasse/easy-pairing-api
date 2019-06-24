class TeamsController < ApplicationController
  before_action :verify_authorization_header, except: :create unless Rails.env.test?
  skip_before_action :verify_authenticity_token

  def create
    team_name = params.require(:name)
    team_members = params.require(:members)
    team_password = params.require(:password)
    team_password_confirmation = params.require(:password_confirmation)

    if team_members.length < 3 || team_password != team_password_confirmation
      return head :bad_request
    end

    team = Team.create(
      name: team_name,
      password: team_password,
      password_confirmation: team_password_confirmation
    )

    team_members.each do |member|
      Member.create(name: member, team_id: team.id)
    end

    head :created
  rescue ActiveRecord::RecordNotUnique, ActionController::ParameterMissing
    return head :bad_request
  rescue StandardError => e
    Rails.logger.info(e.inspect)
    return head :internal_server_error
  end

  def show
    team_id = params[:id]

    begin
      team = Team.find(team_id)

      render json: team, status: :ok
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_server_error
    end
  end

  # TODO: Cover with tests (sorry TDD gods)
  def update
    id = params.require(:id)
    new_name = params.require(:name)

    Team.find(id).update_attributes(name: new_name)

    head :ok
  rescue ActiveRecord::RecordNotFound
    return head :not_found
  rescue ActionController::ParameterMissing
    return head :bad_request
  end
end
