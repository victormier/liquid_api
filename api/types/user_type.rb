UserType = GraphQL::ObjectType.define do
  name "User"
  description "A user"

  field :id, !types.ID
  field :first_name, !types.String
  field :last_name, !types.String
  field :username, !types.String
  field :email, !types.String
  field :posts, -> { types[!PostType] }
  field :comments, -> { types[!CommentType] }
  field :accounts, types[AccountType] do
    resolve -> (obj, args, _ctx) do
      obj.saltedge_accounts
    end
  end
end
