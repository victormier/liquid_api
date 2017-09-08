AccountType = GraphQL::ObjectType.define do
  name "Account"
  description "An account"

  field :id, !types.ID
  field :type, !types.String
  field :saltedge_id, !types.String
  field :currency_code, !types.String
  field :transactions, -> { types[!TransactionType] }
end
