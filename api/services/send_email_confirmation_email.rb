class SendEmailConfirmationEmail
  def initialize(user)
    @user = user
  end

  def call
    # Send a confirmation email
    @user.confirmation_token = SecureRandom.hex(10)
    @user.confirmation_sent_at = Time.now.utc
    @user.save!
    # To Do: Use a background job for sending emails
    mail = LiquidApi.mail("/emails/users/email_confirmation", @user.id)
    mail.reply_to 'noreply@helloliquid.com'
    mail.deliver
  end
end
