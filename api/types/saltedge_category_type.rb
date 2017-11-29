SaltedgeCategoryType = GraphQL::ObjectType.define do
  name "SaltedgeCategory"
  description "A Saltedge Category"

  field :id do
    type !types.ID
    resolve -> (obj, args, ctx) { obj.key }
  end
  field :key, !types.String
  field :name, !types.String
  field :subcategories, types[SaltedgeCategoryType]
end
