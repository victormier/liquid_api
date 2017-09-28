QueryRoot = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :post do
    type PostType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Post.find(args["id"]) }
  end

  field :user do
    type UserType
    resolve -> (obj, args, ctx) { ctx[:current_user] }
  end

  field :all_posts do
    type types[!PostType]
    resolve -> (obj, args, ctx) { Post.all }
  end

  field :all_users do
    type types[!UserType]
    resolve -> (obj, args, ctx) { User.all }
  end

  field :saltedge_provider do
    type SaltedgeProviderType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { SaltedgeProvider.find(args["id"]) }
  end

  field :all_saltedge_providers do
    type types[!SaltedgeProviderType]
    resolve -> (obj, args, ctx) { SaltedgeProvider.all }
  end

  field :saltedge_login do
    type SaltedgeLoginType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { ctx[:current_user].saltedge_logins.find(args["id"]) }
  end

  field :account do
    type AccountInterface
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { ctx[:current_user].virtual_accounts.find(args["id"]) }
  end

  field :all_accounts do
    type types[AccountInterface]
    resolve -> (obj, args, ctx) { ctx[:current_user].virtual_accounts }
  end

  field :transaction do
    type TransactionType
    argument :id, !types.ID
    # TO DO: ADD VALIDATION FOR CURRENT USER ONLY QUERIES
    resolve -> (obj, args, ctx) { Transaction.find(args["id"]) }
  end
end

MutationRoot = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The mutation root of this schema'

  field :registerUser, field: Mutations::RegisterUser
  field :createSaltedgeLogin, field: Mutations::CreateSaltedgeLogin
  field :createVirtualAccount, field: Mutations::CreateVirtualAccount
  field :createVirtualTransaction, field: Mutations::CreateVirtualTransaction
end

Schema = GraphQL::Schema.define do
  query QueryRoot
  mutation MutationRoot

  orphan_types [SaltedgeAccountType]

  resolve_type ->(obj, ctx) {
    Schema.types[obj.class.name]
  }
end
