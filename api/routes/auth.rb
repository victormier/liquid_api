LiquidApi.route("login") do |r|
  r.post do
    params = JSON.parse(request.body.read)
    @user = User.find_by(email: params["email"].downcase)
    if @user && @user.authenticate(params["password"])
      # generate token
      data = { user_id: @user.id }
      auth_token = Rack::JWT::Token.encode(data, ENV['RACK_JWT_SECRET'], 'HS256')
      response['Content-Type'] = 'application/json; charset=utf-8'
      { auth_token: auth_token }.to_json
    else
      response.status = :unauthorized
      { error: 'Invalid username / password' }.to_json
    end
  end
end
