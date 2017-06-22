class User < ActiveRecord::Base
  has_secure_password

  has_many :comments
  has_many :posts

  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save!
  end

  def confirmed?
    !confirmed_at.nil?
  end
end
