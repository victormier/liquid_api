VirtualAccountType = GraphQL::ObjectType.define do
  name "VirtualAccount"
  description "A virtual account"

  interfaces [AccountInterface]

  field :id, !types.ID
  field :transactions do
    type types[!TransactionType]

    resolve -> (obj, args, ctx) {
      []
    }
  end
end
