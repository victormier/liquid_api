module Services
  class LoadSaltedgeAccountTransactions
    def initialize(saltedge_account)
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
    end

    def call
      Services::UpdateSaltedgeAccount.new(@saltedge_account, skip_load_transactions: true).call
      from_id = @saltedge_account.saltedge_transactions.saltedge_id_ordered.first.try(:saltedge_id)

      transactions_data, next_id = retrieve_transactions(from_id)
      while next_id do
        store_transactions_from_data(transactions_data, from_id)
        transactions_data, next_id = retrieve_transactions(next_id)
      end
      store_transactions_from_data(transactions_data, from_id)
    end

    private

    def store_transactions_from_data(transactions_data, except_id = nil)
      transactions_data.each do |transaction_data|
        unless transaction_data["id"].to_s == except_id.to_s
          StoreSaltedgeTransactionWorker.perform_async(@saltedge_account.id, transaction_data)
        end
      end
    end

    def retrieve_transactions(from_id = nil)
      params = {
        account_id: @saltedge_account.saltedge_id
      }
      params[:from_id] = from_id unless from_id.nil?
      response = @saltedge_client.request(:get, "/transactions", params)
      parsed_response = JSON.parse(response.body)

      [parsed_response["data"], parsed_response["meta"]["next_id"]]
    end
  end
end
