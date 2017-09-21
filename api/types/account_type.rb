# AccountType = GraphQL::InterfaceType.define do
#   name("Account")
#   description("An account")
#
#   field :currency_code, !types.String
#   field :name, !types.String
#   field :balance, !types.Float
#   field :transactions, types[!TransactionType]
# end

AccountType = GraphQL::ObjectType.define do
  name "Account"
  description "An account"

  field :id, !types.ID
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  field :transactions do
    type types[!TransactionType]

    resolve -> (obj, args, ctx) {
      obj.respond_to?(:saltedge_transactions) ? obj.saltedge_transactions.newest_first : []
    }
  end
end
