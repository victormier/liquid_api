module LiquidApiUtils
  module Authentication
    def self.get_auth_token_response(user)
      data = { user_id: user.id }
      auth_token = Rack::JWT::Token.encode(data, ENV['RACK_JWT_SECRET'], 'HS256')
      {
        auth_token: auth_token,
        user_id: user.id,
      }
    end
  end
end
