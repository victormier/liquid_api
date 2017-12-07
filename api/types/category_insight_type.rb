CategoryInsightType = GraphQL::ObjectType.define do
  name "Category"
  description "A category insight"

  field :code, !types.String
  field :name, !types.String
  field :amount, !types.Float
  field :percentage, !types.Int
  field :transactions, types[!TransactionType]
end
