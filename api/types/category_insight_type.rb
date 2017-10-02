CategoryInsightType = GraphQL::ObjectType.define do
  name "Category"
  description "A category insight"

  field :name, !types.String
  field :amount, !types.Float
  field :percentage, !types.Int
  field :transactions, types[!TransactionType]
end
