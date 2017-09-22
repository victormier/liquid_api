AccountInterface = GraphQL::InterfaceType.define do
  name("Account Interface")
  description("An account")

  field :id, !types.ID
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  field :transactions, types[!TransactionType]
end
