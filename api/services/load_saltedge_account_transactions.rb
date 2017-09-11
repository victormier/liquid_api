module Services
  class LoadSaltedgeAccountTransactions
    STOREABLE_ATTRIBUTES = %w(saltedge_id saltedge_data status made_on amount currency_code category)

    def initialize(saltedge_account)
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
    end

    def call
      Services::UpdateSaltedgeAccount.new(@saltedge_account).call
      from_id = @saltedge_account.saltedge_transactions.newest_first.last.try(:saltedge_id)

      transactions_data, next_id = retrieve_transactions(from_id)
      store_transactions(transactions_data)
      while next_id do
        store_transactions(transactions_data)
        transactions_data, next_id = retrieve_transactions(next_id)
      end
    end

    private

    def retrieve_transactions(from_id = nil)
      params = {
        account_id: @saltedge_account.saltedge_id
      }
      params[:from_id] = from_id unless from_id.nil?
      response = @saltedge_client.request(:get, "/transactions", params)
      parsed_response = JSON.parse(response.body)

      [parsed_response["data"], parsed_response["meta"]["next_id"]]
    end

    def store_transactions(transactions_hash)
      transactions_hash.each do |transaction_data|
        attrs = transaction_data.select {|k,v| STOREABLE_ATTRIBUTES.include?(k) }
        @saltedge_account.saltedge_transactions.create(attrs.merge({
          saltedge_id: transaction_data["id"],
          saltedge_created_at: transaction_data["created_at"],
          saltedge_data: transaction_data
        }))
      end
    end
  end
end
