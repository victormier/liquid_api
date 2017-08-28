class User < ActiveRecord::Base
  has_secure_password

  has_many :comments
  has_many :posts

  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.now.utc
  end

  def reset_password_token_valid?
    (reset_password_token_generated_at + 1.day) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save!
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def is_saltedge_customer?
    !saltedge_id.nil?
  end
end
