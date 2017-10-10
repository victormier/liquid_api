module Mutations
  UpdatePercentageRule = GraphQL::Field.define do
    name "UpdatePercentageRule"
    description "Updates the data of a percentage rule"
    type PercentageRuleType

    argument :percentage_rule_id, !types.ID
    argument :percentage, !types.Float
    argument :minimum_amount, !types.Float
    argument :active, !types.Boolean

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      service = Services::UpdatePercentageRule.new(ctx[:current_user], args)
      service.call
      service.model
    })
  end
end
