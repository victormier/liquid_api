UserInputType = GraphQL::InputObjectType.define do
  name "UserInput"
  description "Input for a user"

  argument :email, !types.String
  argument :password, !types.String
  argument :password_confirmation, !types.String
  argument :first_name, types.String
  argument :last_name, types.String
end
