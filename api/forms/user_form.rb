class UserForm < BaseForm
  property :first_name
  property :last_name
  property :email
  property :password

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def unique?(attr, value)
        form.model.class.where.not(id: form.model.id).find_by(attr => value).nil?
      end
    end

    required(:email).filled(unique?: :email, format?: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
  end

  def email=(value)
    super(value.try(:downcase).try(:strip))
  end
end
