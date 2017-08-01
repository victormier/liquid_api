require 'pry'

LiquidApi.route("users") do |r|
  r.is do
    r.post do
      params = JSON.parse(request.body.read)
      service = Services::RegisterUser.new(params)

      if service.call
        response_data = LiquidApiUtils::Authentication.get_auth_token_response(service.model)
        # response['Content-Type'] = 'application/json; charset=utf-8'
        response_data.to_json
      else
        errors = service.form.errors || ["There was a problem creating the user"]
        response.status = :unprocessable_entity
        { errors: LiquidApiUtils::Errors.full_messages_array(errors) }.to_json
      end
    end
  end

  r.get "confirm_email" do
    confirmation_token = r['confirmation_token']
    @user = User.find_by(confirmation_token: confirmation_token)
    email_sent = false

    if @user
      if @user.confirmation_token_valid?
        @user.mark_as_confirmed!
        Services::ResetUserPassword.new(@user).call
        url = "https://#{LiquidApi.configuration.default_client_host}/users/reset_password?reset_password_token=#{@user.reload.reset_password_token}"
        response.redirect(url)
      else
        SendEmailConfirmationEmail.new(@user).call
        email_sent = true
      end
    end

    render "users/email_confirmation", locals: { email_sent: email_sent }
  end

  r.post "request_reset_password" do
    params = JSON.parse(request.body.read)
    @user = User.find_by!(email: params["email"])
    Services::SendResetPasswordEmail.new(@user).call
    render "users/request_reset_password"
  end

  r.get "from_reset_password_token" do
    @user = User.find_by!(reset_password_token: request.params["reset_password_token"])
    { user: { id: @user.id, email: @user.email } }.to_json
  end

  r.on :id do |user_id|
    @user = User.find(user_id)

    r.post "set_password" do
      params = JSON.parse(request.body.read)
      service = Services::SetUserPassword.new(@user, params)

      if @user.confirmed? && service.call
        LiquidApiUtils::Authentication.get_auth_token_response(@user).to_json
      else
        errors = service.errors || ["There was a problem saving the password"]
        response.status = :unprocessable_entity
        { errors: errors }.to_json
      end
    end
  end
end
