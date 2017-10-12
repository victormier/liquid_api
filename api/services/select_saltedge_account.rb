module Services
  class SelectSaltedgeAccount
    def initialize(saltedge_account)
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
    end

    def call
      ActiveRecord::Base.transaction do
        form = SaltedgeAccountForm.new(@saltedge_account)
        form.validate({ selected: true })
        if form.valid?
          form.save
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
          raise ActiveRecord::RecordInvalid.new(errors)
        end

        virtual_account = VirtualAccount.new(
          user: @saltedge_account.user,
          name: @saltedge_account.name,
          saltedge_account: @saltedge_account,
          balance: @saltedge_account.balance,
          currency_code: @saltedge_account.currency_code
        )
        form = VirtualAccountForm.new(virtual_account)
        if form.valid?
          form.save
        else
          raise LiquidApi::MutationInvalid.new(nil, errors: form.errors)
        end
      end
    end
  end
end
