module Services
  class SaveSaltedgeTransaction
    def initialize(saltedge_account_id, transaction_data)
      @saltedge_account = SaltedgeAccount.find(saltedge_account_id)
      @transaction_data = transaction_data
    end

    def call
      rules = @saltedge_account.user.rules
      return if @saltedge_account.saltedge_transactions.find_by(saltedge_id: @transaction_data["id"]).present?

      begin
        mirror_transaction = nil

        SaltedgeTransaction.transaction do
          # Create saltedge transaction
          saltedge_transaction_form = SaltedgeTransactionForm.new(@saltedge_account.saltedge_transactions.new)
          saltedge_transaction_form.validate({
            saltedge_id: @transaction_data["id"],
            saltedge_created_at: @transaction_data["created_at"],
            saltedge_data: @transaction_data
          })
          if saltedge_transaction_form.valid?
            saltedge_transaction_form.save
          else
            errors = LiquidApiUtils::Errors::ErrorObject.new(saltedge_transaction_form.errors)
            raise LiquidApi::MutationInvalid.new(errors.full_messages.join('; '), errors: errors)
          end
          saltedge_transaction = saltedge_transaction_form.model

          # Create mirror transaction
          mirror_transaction = MirrorTransaction.new(
            saltedge_transaction: saltedge_transaction,
            virtual_account: @saltedge_account.virtual_account,
            amount: saltedge_transaction.amount,
            made_on: saltedge_transaction.made_on.to_datetime,
            saltedge_id: saltedge_transaction.saltedge_id
          )
          mirror_transaction_form = MirrorTransactionForm.new(mirror_transaction)
          if mirror_transaction_form.valid?
            mirror_transaction_form.save!
          else
            errors = LiquidApiUtils::Errors::ErrorObject.new(mirror_transaction_form.errors)
            raise LiquidApi::MutationInvalid.new(errors.full_messages.join('; '), errors: errors)
          end

          @saltedge_account.virtual_account.compute_balance!
        end

        # Create automatic transaction
        rules.each do |rule|
          rule.apply_rule(mirror_transaction.reload)
        end
      rescue LiquidApi::MutationInvalid => e
        if ENV['RACK_ENV'] == "production"
          Rollbar.error(e, transaction_data: @transaction_data, saltedge_account_id: @saltedge_account.id)
        end
        raise e
      end
    end
  end
end
