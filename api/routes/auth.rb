LiquidApi.route("login") do |r|
  r.post do
    params = JSON.parse(request.body.read)
    login_form = LoginForm.new

    if login_form.validate(params)
      @user = User.find_by(email: login_form.email)
    end

    if @user && @user.authenticate(login_form.password)
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
