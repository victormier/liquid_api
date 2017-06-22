class RegisterUser
  def initialize(params)
    @params = params
    @form = UserForm.new(User.new)
  end

  def call
    if @form.validate(@params)
      if @form.save
        user = @form.model
        # Send a confirmation email
        user.confirmation_token = SecureRandom.hex(10)
        user.confirmation_sent_at = Time.now.utc
        user.save!
        # To Do: Use a background job for sending emails
        LiquidApi.sendmail("/emails/users/email_confirmation", user.id)
        true
      else
        # this shouldn't be a validation error
        raise "There was a problem saving the user"
      end
    end
  end

  attr_accessor :form

  def model
    form.model
  end
end
