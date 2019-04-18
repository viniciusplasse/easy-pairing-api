module AuthenticationHelper
  def encode(payload, expiration_time = 24.hours.from_now)
    payload[:expiration_time] = expiration_time.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s)
  end

  def decode(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base.to_s).first
    HashWithIndifferentAccess.new decoded
  end
end