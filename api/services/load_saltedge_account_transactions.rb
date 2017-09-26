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
        SaltedgeTransaction.transaction do
          # Create saltedge transaction
          saltedge_transaction = @saltedge_account.saltedge_transactions.create!(attrs.merge({
            saltedge_id: transaction_data["id"],
            saltedge_created_at: transaction_data["created_at"],
            saltedge_data: transaction_data
          }))
          # Create mirror transaction
          mirror_transaction = MirrorTransaction.new(
            saltedge_transaction: saltedge_transaction,
            virtual_account: @saltedge_account.virtual_account,
            amount: saltedge_transaction.amount,
            made_on: saltedge_transaction.made_on.to_datetime
          )
          transaction_form = MirrorTransactionForm.new(mirror_transaction)
          if transaction_form.valid?
            transaction_form.save!
          else
            errors = LiquidApiUtils::Errors::ErrorObject.new(transaction_form.errors)
            raise LiquidApi::MutationInvalid.new(nil, errors: errors)
          end
        end
      end
    end
  end
end
