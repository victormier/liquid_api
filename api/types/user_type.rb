UserType = GraphQL::ObjectType.define do
  name "User"
  description "A user"

  field :id, !types.ID
  field :first_name, !types.String
  field :last_name, !types.String
  field :username, !types.String
  field :email, !types.String
  field :accounts, types[AccountInterface] do
    resolve -> (obj, args, _ctx) do
      obj.virtual_accounts
    end
  end
  field :bank_connection_phase, !types.String
  field :saltedge_logins, types[SaltedgeLoginType]
  field :total_balance, !types.Float
  field :currency_code, types.String
end
