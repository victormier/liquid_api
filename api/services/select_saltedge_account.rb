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
        data: {
          login_id: @saltedge_login.saltedge_id,
        }
      })
      data = JSON.parse(response.body)
      accounts = data["data"].select do |a|
        SaltedgeAccount::ACCOUNT_NATURE_WHITELIST.include?(a["nature"])
      end
      if account_data = accounts.first
        @saltedge_account = @saltedge_login.user.saltedge_accounts.create(
          saltedge_login: @saltedge_login,
          saltedge_id: account_data["id"],
          saltedge_data: account_data
        )
      end
    end
  end
end
