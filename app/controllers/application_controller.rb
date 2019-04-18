class ApplicationController < ActionController::Base
  include AuthenticationHelper

  def verify_authorization_header
    header = request.headers['Authorization']
    decode(header)
  rescue JWT::DecodeError
    head :unauthorized
  end
end
