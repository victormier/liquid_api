module Services
  class SendResetPasswordEmail
    def initialize(user)
      @user = user
    end

    def call
      # Reset user password
      Services::ResetUserPassword.new(@user).call
      # To Do: Use a background job for sending emails
      LiquidApi.sendmail("/emails/users/reset_password", @user.id)
    end
  end
end
