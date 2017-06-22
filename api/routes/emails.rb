LiquidApi.route("emails") do |r|
  from "hello@helloliquid.com"

  r.on "users" do
    r.mail "email_confirmation", Integer do |user_id|
      @user = User.find(user_id)
      to @user.email
      subject "Liquid email confirmation"
      set_layout_locals user: @user
      render "emails/users/email_confirmation"
    end
  end
end
