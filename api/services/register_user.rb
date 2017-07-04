module Services
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
          SendEmailConfirmationEmail.new(user).call
          true
        else
          # this shouldn't be a reform validation error
          # could be an ActiveRecord validation error or db error
          # (e.g.: no password from has_secure_password)
          raise "There was a problem saving the user"
        end
      else
        raise LiquidApi::MutationInvalid.new(errors: @form.errors)
      end
    end

    attr_accessor :form

    def model
      form.model
    end
  end
end
