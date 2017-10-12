SaltedgeAccountType = GraphQL::ObjectType.define do
  name "SaltedgeAccount"
  description "A Saltedge Account"

  interfaces [AccountInterface]

  field :id, !types.ID
  field :selected, !types.Boolean
  field :transactions do
    type types[!TransactionType]

    resolve -> (obj, args, ctx) {
      obj.saltedge_transactions.newest_first
    }
  end
end
