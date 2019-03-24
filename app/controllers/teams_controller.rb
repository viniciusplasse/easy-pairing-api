class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    name = params[:name]
    members = params[:members]

    if name.nil? || members.nil? || members.length < 3
      return head :bad_request
    end

    head :created
  end
end
