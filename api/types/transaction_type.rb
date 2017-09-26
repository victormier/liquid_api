TransactionType = GraphQL::ObjectType.define do
  name "Transaction"
  description "A transaction"

  field :id, !types.ID
  field :type, !types.String
  field :amount, !types.Float
  field :saltedge_id, types.String
  field :category, types.String
  field :description, types.String
  field :made_on do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.made_on.to_time.to_i
    }
  end
  field :created_at do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.respond_to?(:saltedge_transaction) ? obj.saltedge_transaction.saltedge_created_at.to_i : obj.created_at.to_i
    }
  end
end
