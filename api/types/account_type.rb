AccountType = GraphQL::ObjectType.define do
  name "Account"
  description "An account"

  field :id, !types.ID
  field :type, !types.String
  field :saltedge_id, !types.String
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  field :transactions do
    type types[!TransactionType]

    resolve -> (obj, args, ctx) {
      obj.saltedge_transactions.newest_first
    }
  end
end
