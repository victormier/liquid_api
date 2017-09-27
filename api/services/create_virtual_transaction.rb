module Services
  class CreateVirtualTransaction
    def initialize(user, params)
      @user = user
      @amount = params["amount"]
      if @amount.to_f <= 0.0
        raise LiquidApi::MutationInvalid.new(nil, {errors:{"amount" => "must be greater than 0"}})
      end

      @origin_account = @user.virtual_accounts.find(params["origin_account_id"])
      @destination_account = @user.virtual_accounts.find(params["destination_account_id"])
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
        form = VirtualTransactionForm.new(virtual_transaction)
        if form.valid?
          form.save!
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end

        # Debit transaction
        virtual_transaction = VirtualTransaction.new({
          made_on: @made_on,
          amount: @amount.to_f,
          virtual_account_id: @destination_account.id,
          related_virtual_account_id: @origin_account.id
        })
        form = VirtualTransactionForm.new(virtual_transaction)
        if form.valid?
          form.save!
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end
      end
    end

    attr_accessor :form

    def model
      form.model
    end
  end
end
