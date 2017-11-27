VirtualAccountType = GraphQL::ObjectType.define do
  name "VirtualAccount"
  description "A virtual account"

  interfaces [AccountInterface]

  field :id, !types.ID
  field :is_mirror_account, !types.Boolean
  field :is_refreshing, types.Boolean
  field :last_updated do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.last_updated.try(:to_time).try(:to_i)
    }
  end
  field :saltedge_account, -> { SaltedgeAccountType }
end
