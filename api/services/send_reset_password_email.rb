module Services
  class SendResetPasswordEmail
    def initialize(user)
      @user = user
    end

    def call
      # Reset user password
      Services::ResetUserPassword.new(@user).call
      # To Do: Use a background job for sending emails
      mail = LiquidApi.mail("/emails/users/reset_password", @user.id)
      mail.reply_to 'noreply@helloliquid.com'
      mail.deliver
    end
  end
end
