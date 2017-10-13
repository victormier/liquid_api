module Mutations
  SelectSaltedgeAccount = GraphQL::Field.define do
    name "SelectSaltedgeAccount"
    description "Selects a SaltedgeAccount to be "
    type SaltedgeAccountType

    argument :saltedge_account_id, !types.ID

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      service = Services::SelectSaltedgeAccount.new(ctx[:current_user], args[:saltedge_account_id])
      service.call
      service.saltedge_account
    })
  end
end
