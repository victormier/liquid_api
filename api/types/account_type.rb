AccountType = GraphQL::ObjectType.define do
  name "Account"
  description "An account"

  field :id, !types.ID
  field :type, !types.String
  field :saltedge_id, !types.String
  field :currency_code, !types.String
  field :name, !types.String
  field :balance, !types.Float
  field :transactions, -> { types[!TransactionType] }
end
