class ApplicationController < ActionController::Base
  include AuthenticationHelper

  def verify_authorization_header
    header = request.headers['Authorization']
    decode(header)
  rescue JWT::DecodeError => e
    Rails.logger.info('Authorization error: ' + e.inspect)
    head :unauthorized
  end
end
