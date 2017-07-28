module Services
  class ResetUserPassword
    def initialize(user)
      @user = user
    end

    def call
      # This doesn't actually reset the password
      @user.reset_password_token = SecureRandom.hex(10)
      @user.reset_password_token_generated_at = Time.now.utc
      @user.save!
    end
  end
end
