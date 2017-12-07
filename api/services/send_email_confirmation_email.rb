class SendEmailConfirmationEmail
  def initialize(user)
    @user = user
  end

  def call
    # Send a confirmation email
    @user.confirmation_token = SecureRandom.hex(10)
    @user.confirmation_sent_at = Time.now.utc
    @user.save!
    SendEmailWorker.perform_async("/emails/users/email_confirmation", @user.id)
  end
end
