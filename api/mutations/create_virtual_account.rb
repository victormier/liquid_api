module Mutations
  CreateVirtualAccount = GraphQL::Field.define do
    name "createVirtualAccount"
    description "Creates a new VirtualAccount for a user"
    type VirtualAccountType

    argument :name, !types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      service = Services::CreateVirtualAccount.new(ctx[:current_user], { name: args[:name] })

      if service.call
        service.model
      else
        raise LiquidApi::MutationInvalid.new(nil, errors: service.form.errors)
      end
    })
  end
end
