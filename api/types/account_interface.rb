AccountInterface = GraphQL::InterfaceType.define do
  name("AccountInterface")
  description("An account")

  field :id, !types.ID
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  field :transactions do
    type types[!TransactionType]

    resolve -> (obj, args, ctx) {
      obj.transactions.newest_first
    }
  end
end
