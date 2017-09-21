class VirtualAccountForm < BaseForm
  property :name
  property :currency_code
  property :user_id

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def unique?(attr, value)
        form.model.user.virtual_accounts.where.not(id: form.model.id).find_by(attr => value).nil?
      end

      def valid_currency?(value)
        Money::Currency.all.map(&:iso_code).include?(value)
      end
    end

    required(:name).filled(unique?: :name)
    required(:currency_code).filled(:valid_currency?)
    required(:user_id).filled
  end
end
