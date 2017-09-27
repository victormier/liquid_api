module Services
  class CreateVirtualTransaction
    attr_reader :credit_tx_form, :debit_tx_form

    def initialize(user, params)
      params_h = ActiveSupport::HashWithIndifferentAccess.new(params)
      @user = user
      @amount = params_h["amount"]
      if @amount.to_f <= 0.0
        raise LiquidApi::MutationInvalid.new(nil, { "errors" => {"amount" => "must be greater than 0"}})
      end

      @origin_account = @user.virtual_accounts.find(params_h["origin_account_id"])
      @destination_account = @user.virtual_accounts.find(params_h["destination_account_id"])
      @made_on = DateTime.now
    end

    def call
      # TO DO: Add some sort of proper authorization (both accounts belong to the user)
      VirtualTransaction.transaction do
        # Credit transaction
        virtual_transaction = VirtualTransaction.new({
          made_on: @made_on,
          amount: -@amount.to_f,
          virtual_account_id: @origin_account.id,
          related_virtual_account_id: @destination_account.id
        })
        @credit_tx_form = VirtualTransactionForm.new(virtual_transaction)
        if @credit_tx_form.valid?
          @credit_tx_form.save!
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(@credit_tx_form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end

        # Debit transaction
        virtual_transaction = VirtualTransaction.new({
          made_on: @made_on,
          amount: @amount.to_f,
          virtual_account_id: @destination_account.id,
          related_virtual_account_id: @origin_account.id
        })
        @debit_tx_form = VirtualTransactionForm.new(virtual_transaction)
        if @debit_tx_form.valid?
          @debit_tx_form.save!
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(@debit_tx_form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end
      end
    end

    def errors
      @credit_tx_form.errors || @debit_tx_form.errors || []
    end
  end
end
