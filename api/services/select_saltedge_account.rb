module Services
  class SelectSaltedgeAccount
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

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
        @saltedge_login.user.saltedge_accounts.create(
          saltedge_login: @saltedge_login,
          saltedge_id: account_data["id"]
        )
      end
    end
  end
end
