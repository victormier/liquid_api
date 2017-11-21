VirtualAccountType = GraphQL::ObjectType.define do
  name "VirtualAccount"
  description "A virtual account"

  interfaces [AccountInterface]

  field :id, !types.ID
  field :is_mirror_account, !types.Boolean
  field :saltedge_account, -> { SaltedgeAccountType }
end
