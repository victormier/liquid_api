module Services
  class LoadSaltedgeAccountTransactions
    def initialize(saltedge_account)
      @saltedge_account = saltedge_account
      @saltedge_client = SaltedgeClient.new
    end

    def call
      Services::UpdateSaltedgeAccount.new(@saltedge_account).call
      from_id = @saltedge_account.saltedge_transactions.newest_first.last.try(:saltedge_id)

      transactions_data, next_id = retrieve_transactions(from_id)
      while next_id do
        transactions_data.each do |transaction_data|
          StoreSaltedgeTransactionWorker.perform_async(@saltedge_account.id, transaction_data)
        end
        transactions_data, next_id = retrieve_transactions(next_id)
      end
      transactions_data.each do |transaction_data|
        StoreSaltedgeTransactionWorker.perform_async(@saltedge_account.id, transaction_data)
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
  end
end
