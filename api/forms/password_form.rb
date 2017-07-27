class PasswordForm < BaseForm
  property :password
  property :password_confirmation

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def same_password?(value)
        value == form.password
      end
    end

    required(:password).filled(max_size?: 72)
    required(:password_confirmation).filled(:same_password?)
  end
end
