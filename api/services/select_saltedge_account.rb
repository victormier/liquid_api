module Services
  class SelectSaltedgeAccount
    attr_accessor :saltedge_account

    def initialize(user, saltedge_account_id)
      @user = user
      @saltedge_account = @user.saltedge_accounts.find(saltedge_account_id)
    end

    def call
      ActiveRecord::Base.transaction do
        form = SaltedgeAccountForm.new(@saltedge_account)
        form.validate({ selected: true })
        if form.valid?
          form.save
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
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
          errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end
      end

      # initial transaction load
      Services::LoadSaltedgeAccountTransactions.new(@saltedge_account).call
    end
  end
end
