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
  field :needs_reconnection, !types.Boolean
  field :is_refreshing, !types.Boolean
  field :interactive_session_active, !types.Boolean do
    resolve -> (obj, args, _ctx) do
      obj.interactive_session_active?
    end
  end
  field :interactive_html, types.String do
    resolve -> (obj, args, _ctx) do
      obj.interactive_data["html"]
    end
  end
  field :interactive_fields, types[types.String] do
    resolve -> (obj, args, _ctx) do
      obj.interactive_data["interactive_fields_names"]
    end
  end
end
