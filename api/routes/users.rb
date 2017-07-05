LiquidApi.route("users") do |r|
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
