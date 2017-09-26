module Services
  class SelectSaltedgeAccount
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
      @saltedge_account = nil
    end

    attr_reader :saltedge_account

    def call
      response = @saltedge_client.request(:get, "/accounts", {
        login_id: @saltedge_login.saltedge_id
      })
      data = JSON.parse(response.body)
      accounts = data["data"].select do |a|
        SaltedgeAccount::ACCOUNT_NATURE_WHITELIST.include?(a["nature"])
      end
      if account_data = accounts.first
        SaltedgeAccount.transaction do
          @saltedge_account = @saltedge_login.user.saltedge_accounts.create!(
            saltedge_login: @saltedge_login,
            saltedge_id: account_data["id"],
            saltedge_data: account_data
          )
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
            raise ActiveRecord::RecordInvalid.new(errors)
          end
        end
      end
    end
  end
end
