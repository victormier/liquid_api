module Mutations
  RegisterUser = GraphQL::Field.define do
    name "registerUser"
    description "Registers a user"
    type UserType

    argument :user, UserInputType

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, c) {
      service = Services::RegisterUser.new(args[:user].to_h)

      if service.call
        service.model
      end
    })
  end
end
