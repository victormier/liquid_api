CategoryType = GraphQL::ObjectType.define do
  name "Category"
  description "A category"

  field :id, !types.ID
  field :name, !types.String
  field :post, -> { PostType }
end
