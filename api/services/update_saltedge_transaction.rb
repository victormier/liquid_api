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
      if transaction_data
        form = SaltedgeTransactionForm.new(@saltedge_transaction)
        form.validate({saltedge_data: transaction_data})
        if form.valid?
          form.save
        end
      end
    end
  end
end