module Mutations
  KillUser = GraphQL::Field.define do
    name "KillUser"
    description "Kills/deactivates user and schedules data to be removed in #{Services::KillUser::DAYS_TO_KEEP_DATA} days"
    type types.Boolean

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      Services::KillUser.new(ctx[:current_user]).call
      true
    })
  end
end
