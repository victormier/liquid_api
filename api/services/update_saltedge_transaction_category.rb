module Services
  class UpdateSaltedgeTransactionCategory
    def initialize(saltedge_transaction, category_code)
      @saltedge_transaction = saltedge_transaction
      @saltedge_client = SaltedgeClient.new
      @category_code = category_code
    end

    def call
      params = {
        data: [
          {
            transaction_id: @saltedge_transaction.saltedge_id,
            category_code: @category_code
          }
        ]
      }
      response = @saltedge_client.request(:post, "/categories/learn", params)
      data = JSON.parse(response.body)
      if data["data"] && data["data"]["learned"]
        Services::UpdateSaltedgeTransaction.new(@saltedge_transaction).call
      end
    end
  end
end
