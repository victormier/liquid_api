module Services
  class UpdateSaltedgeTransaction
    def initialize(saltedge_transaction)
      @saltedge_transaction = saltedge_transaction
      @saltedge_client = SaltedgeClient.new
    end
    
    def call
      params = {
        account_id: @saltedge_transaction.saltedge_account.saltedge_id,
        from_id: @saltedge_transaction.saltedge_id
      }
      response = @saltedge_client.request(:get, "/transactions", params)
      parsed_response = JSON.parse(response.body)
      transaction_data = parsed_response["data"].find{|t| t["id"].to_s == @saltedge_transaction.saltedge_id}
      @saltedge_transaction.update_attributes(saltedge_data: transaction_data)
    end
  end
end