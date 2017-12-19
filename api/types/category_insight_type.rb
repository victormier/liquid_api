CategoryInsightType = GraphQL::ObjectType.define do
  name "Category"
  description "A category insight"

  field :id, !types.ID do
    resolve -> (obj, args, _ctx) do
      "#{obj.code}_#{obj.transactions.map(&:id).join("_")}"
    end
  end
  field :code, !types.String
  field :name, !types.String
  field :amount, !types.Float
  field :percentage, !types.Int
  field :transactions, types[!TransactionType]
end
