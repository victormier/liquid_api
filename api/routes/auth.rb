LiquidApi.route("login") do |r|
  r.post do
    params = JSON.parse(request.body.read)
    login_form = LoginForm.new

    if login_form.validate(params)
      @user = User.find_by(email: login_form.email)
    end

    if @user && @user.authenticate(login_form.password) && @user.confirmed?
      # generate token
      response_data = LiquidApiUtils::Authentication.get_auth_token_response(@user)
      response['Content-Type'] = 'application/json; charset=utf-8'
      response_data.to_json
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
