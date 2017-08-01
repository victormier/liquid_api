module Services
  class SetUserPassword
    def initialize(user, params)
      @params = params
      @user = user
      @form = PasswordForm.new(@user)
    end

    def call
      if @form.validate(@params) && @form.save
        @user.update_attributes(reset_password_token: nil, reset_password_token_generated_at: nil)
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
