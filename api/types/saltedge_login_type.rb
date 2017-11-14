SaltedgeLoginType = GraphQL::ObjectType.define do
  name "SaltedgeLogin"
  description "A saltedge login for a user"

  field :id, !types.ID
  field :saltedge_id, !types.ID
  field :user, -> { UserType }
  field :saltedge_provider, -> { SaltedgeProviderType }
  field :active, !types.Boolean
  field :finished_connecting, !types.Boolean
  field :error, types.String
  field :killed, !types.Boolean
  field :error_message, types.String
end
