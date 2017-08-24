QueryRoot = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :post do
    type PostType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Post.find(args["id"]) }
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
end

MutationRoot = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The mutation root of this schema'

  field :registerUser, field: Mutations::RegisterUser
end

Schema = GraphQL::Schema.define do
  query QueryRoot
  mutation MutationRoot
end
