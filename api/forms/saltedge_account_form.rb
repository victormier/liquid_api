class SaltedgeAccountForm < BaseForm
  property :saltedge_login_id
  property :user_id
  property :saltedge_id
  property :saltedge_data
  property :selected

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def unique?(attr, value)
        return false unless form.model.user
        form.model.user.saltedge_accounts.where.not(id: form.model.id).find_by(attr => value).nil?
      end

      def unique_true?(attr, value)
        form.model.user.saltedge_accounts.where(attr => true).empty?
      end

      def valid_currency?(value)
        Money::Currency.all.map(&:iso_code).include?(value)
      end
    end

    required(:saltedge_login_id).filled
    required(:saltedge_id).filled(unique?: :saltedge_id)
    optional(:selected).filled(:bool?, unique_true?: :selected)
  end
end
