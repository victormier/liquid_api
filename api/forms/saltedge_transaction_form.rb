class SaltedgeTransactionForm < BaseForm
  property :saltedge_data
  property :saltedge_created_at
  property :saltedge_id
  property :status
  property :made_on
  property :amount
  property :currency_code
  property :category

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def unique?(attr, value)
        return false unless form.model.saltedge_account
        form.model.saltedge_account.saltedge_transactions.where.not(id: form.model.id).find_by(attr => value).nil?
      end

      def valid_currency?(value)
        Money::Currency.all.map(&:iso_code).include?(value)
      end
    end

    required(:saltedge_id).filled(unique?: :saltedge_id)
    required(:saltedge_data).filled(:hash?)
    required(:saltedge_created_at).filled(:time?)
    required(:status).filled(included_in?: ["posted", "pending"])
    required(:made_on).filled(:date?)
    required(:amount).filled(:decimal?)
    required(:currency_code).filled(:valid_currency?)
    optional(:category).filled(:str?)
  end
end
