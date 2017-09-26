VirtualAccountType = GraphQL::ObjectType.define do
  name "VirtualAccount"
  description "A virtual account"

  interfaces [AccountInterface]

  field :id, !types.ID
end
