SaltedgeAccountType = GraphQL::ObjectType.define do
  name "SaltedgeAccount"
  description "A Saltedge Account"

  # interfaces [AccountType]

  field :id, !types.ID
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
