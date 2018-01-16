LiquidApi.route("emails") do |r|
  from "Liquid <hello@helloliquid.com>"

  r.on "users" do
    r.mail "email_confirmation", Integer do |user_id|
      @user = User.find(user_id)
      to @user.email
      subject "Create your Liquid account"
      render "emails/users/confirm_email"
    end

    r.mail "reset_password", Integer do |user_id|
      @user = User.find(user_id)
      @reset_password_url = "https://#{LiquidApi.configuration.default_client_host}/users/reset_password?reset_password_token=#{@user.reset_password_token}"
      to @user.email
      subject "Liquid reset password"
      render "emails/users/reset_password"
    end
  end
end
