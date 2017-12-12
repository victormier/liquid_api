class SendEmailWorker
  include Sidekiq::Worker

  def perform(email_path, user_id)
    mail = LiquidApi.mail(email_path, user_id)
    mail.reply_to 'noreply@helloliquid.com'
    mail.deliver
  end
end
