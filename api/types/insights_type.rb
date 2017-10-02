InsightsType = GraphQL::ObjectType.define do
  name "Insights"
  description "An insights object"

  field :income_transactions, types[!TransactionType]
  field :total_income, !types.Float
  field :total_expense, !types.Float
  field :mirror_account, VirtualAccountType
  field :category_insights, types[CategoryInsightType]
end
