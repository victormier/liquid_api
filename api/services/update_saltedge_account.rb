module Services
  class UpdateSaltedgeAccount
    def initialize(saltedge_account)
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
    end

    def call
      response = @saltedge_client.request(:get, "/accounts", {
        data: {
          login_id: @saltedge_login.saltedge_id,
        }
      })
      data = JSON.parse(response.body)
      account_data = data["data"].find { |a| a.id = @saltedge_account.saltedge_id }

      if account_data
        @saltedge_account.update_attributes({
          saltedge_data: account_data
        })
      end
    end
  end
end
