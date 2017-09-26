class VirtualTransactionForm < TransactionForm
  property :related_virtual_account_id

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def enough_balance?(virtual_account_id)
        return false unless (form.amount && !form.errors[:amount].any?)
        return true if form.amount >= 0.0

        virtual_account = VirtualAccount.where(id: virtual_account_id).first

        if virtual_account
          (virtual_account.balance + form.amount) > 0.0
        end
      end

      def is_record?(klass, value)
        klass.where(id: value).any?
      end

      def same_currency?(attr, virtual_account_id)
        virtual_account = VirtualAccount.where(id: form.virtual_account_id).first
        related_virtual_account = VirtualAccount.where(id: form.send(attr)).first

        return false unless virtual_account && related_virtual_account
        virtual_account.currency_code == related_virtual_account.currency_code
      end
    end

    required(:related_virtual_account_id).filled(is_record?: VirtualAccount)
    required(:virtual_account_id).filled(:enough_balance?, is_record?: VirtualAccount, same_currency?: :related_virtual_account_id)
  end
end
