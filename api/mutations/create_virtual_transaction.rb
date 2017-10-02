module Mutations
  CreateVirtualTransaction = GraphQL::Field.define do
    name "createVirtualTransaction"
    description "Creates a new VirtualTransaction between accounts of a user"
    type types.Boolean

    argument :origin_account_id, !types.ID
    argument :destination_account_id, !types.ID
    argument :amount, !types.Float

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      service = Services::CreateVirtualTransaction.new(ctx[:current_user], args)

      if service.call
        true
      else
        raise LiquidApi::MutationInvalid.new(nil, errors: service.errors)
      end
    })
  end
end
