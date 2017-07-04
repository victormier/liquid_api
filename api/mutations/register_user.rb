module Mutations
  RegisterUser = GraphQL::Field.define do
    name "registerUser"
    description "Registers a user"
    type UserType

    argument :email, !types.String
    argument :password, !types.String
    argument :first_name, types.String
    argument :last_name, types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, c) {
      service = Services::RegisterUser.new(args.to_h)

      if service.call
        service.model
      end
    })
  end
end
