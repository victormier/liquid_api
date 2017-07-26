LiquidApi.route("users") do |r|
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

  r.get "confirm_email" do
    confirmation_token = r['confirmation_token']
    @user = User.find_by(confirmation_token: confirmation_token)
    email_sent = false

    if @user
      if @user.confirmation_token_valid?
        @user.mark_as_confirmed!
      else
        SendEmailConfirmationEmail.new(@user).call
        email_sent = true
      end
    end

    render "users/email_confirmation", locals: { email_sent: email_sent }
  end
end
