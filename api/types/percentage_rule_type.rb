PercentageRuleType = GraphQL::ObjectType.define do
  name "PercentageRule"
  description "A percentage-based (taxes) rule for creating automatic transactions"

  field :id, types.ID
  field :active, types.Boolean
  field :destination_virtual_account, VirtualAccountType
  field :minimum_amount do
    type !types.Float

    resolve -> (obj, args, ctx) {
      obj.config[:minimum_amount]
    }
  end
  field :percentage do
    type !types.Float

    resolve -> (obj, args, ctx) {
      obj.config[:percentage]
    }
  end
end
