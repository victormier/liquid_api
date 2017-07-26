LiquidApi.route("login") do |r|
  r.post do
    params = JSON.parse(request.body.read)
    login_form = LoginForm.new

    if login_form.validate(params)
      @user = User.find_by(email: login_form.email)
    end

    if @user && @user.authenticate(login_form.password) && @user.confirmed?
      # generate token
      data = { user_id: @user.id }
      auth_token = Rack::JWT::Token.encode(data, ENV['RACK_JWT_SECRET'], 'HS256')
      response['Content-Type'] = 'application/json; charset=utf-8'
      {
        auth_token: auth_token,
        user_id: @user.id,
      }.to_json
    elsif @user && !@user.confirmed?
      response.status = :unauthorized
      { errors: ['Email is not confirmed'] }.to_json
    elsif login_form.errors.present?
      response.status = :unauthorized
      { errors: login_form.full_error_messages }.to_json
    else
      response.status = :unauthorized
      { errors: ['Invalid username / password'] }.to_json
    end
  end
end
