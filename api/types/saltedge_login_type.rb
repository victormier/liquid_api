SaltedgeLoginType = GraphQL::ObjectType.define do
  name "SaltedgeLogin"
  description "A saltedge login for a user"

  field :id, !types.ID
  field :saltedge_id, !types.ID
  field :user, -> { UserType }
  field :saltedge_provider, -> { SaltedgeProviderType }
end
