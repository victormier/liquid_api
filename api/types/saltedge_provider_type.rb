SaltedgeProviderType = GraphQL::ObjectType.define do
  name "SaltedgeProvider"
  description "A saltedge provider for account connection"

  field :id, !types.ID
  field :name, !types.String
  field :country_code, !types.String
end
