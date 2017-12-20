InsightsType = GraphQL::ObjectType.define do
  name "Insights"
  description "An insights object"

  field :id, !types.ID do
    resolve -> (obj, args, _ctx) do
      "#{obj.mirror_account.id}_#{obj.start_date.to_time.to_i}_#{obj.end_date.to_time.to_i}"
    end
  end
  field :income_transactions, types[!TransactionType]
  field :total_income, !types.Float
  field :total_expense, !types.Float
  field :total_balance, !types.Float
  field :mirror_account, VirtualAccountType
  field :category_insights, types[CategoryInsightType]
  field :start_date do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.start_date.to_time.to_i
    }
  end
  field :end_date do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.end_date.to_time.to_i
    }
  end
end
