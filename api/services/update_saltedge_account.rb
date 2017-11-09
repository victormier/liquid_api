module Services
  class UpdateSaltedgeAccount
    def initialize(saltedge_account, account_data = {})
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
      @account_data = account_data
    end

    def call
      unless @account_data.present?
        response = @saltedge_client.request(:get, "/accounts", {
          login_id: @saltedge_account.saltedge_login.saltedge_id
        })
        data = JSON.parse(response.body)
        @account_data = data["data"].find { |a| a["id"].to_s == @saltedge_account.saltedge_id }
      end

      if @account_data.present?
        @saltedge_account.update_attributes({
          saltedge_data: @account_data
        })
      end

      if @saltedge_account.virtual_account.present?
        LoadTransactionsWorker.perform_async(@saltedge_account.id)
        @saltedge_account.virtual_account.compute_balance!
      end

    end
  end
end
