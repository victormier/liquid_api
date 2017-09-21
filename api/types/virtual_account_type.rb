VirtualAccountType = GraphQL::ObjectType.define do
  name "VirtualAccount"
  description "A virtual account"

  field :id, !types.ID
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  # field :transactions do
  #   type types[!TransactionType]
  #
  #   resolve -> (obj, args, ctx) {
  #     obj.saltedge_transactions.newest_first
  #   }
  # end
end
