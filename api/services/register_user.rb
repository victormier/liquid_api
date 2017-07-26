module Services
  class RegisterUser
    def initialize(params)
      @params = params
      @form = UserForm.new(User.new)
    end

    def call
      if @form.validate(@params) && @form.save
        user = @form.model
        # Send a confirmation email
        SendEmailConfirmationEmail.new(user).call
        true
      else
        false
      end
    end

    attr_accessor :form

    def model
      form.model
    end
  end
end
