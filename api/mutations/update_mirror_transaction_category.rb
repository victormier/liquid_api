module Mutations
  UpdateMirrorTransactionCategory = GraphQL::Field.define do
    name "UpdateMirrorTransactionCategory"
    description "Updates the category of a transaction. Only for mirror transactions now."
    type TransactionType

    argument :mirror_transaction_id, !types.ID
    argument :category_code, !types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      mirror_transaction = ctx[:current_user].default_mirror_account.transactions.mirror.find(args[:mirror_transaction_id])
      service = Services::UpdateMirrorTransactionCategory.new(mirror_transaction, args[:category_code])
      service.call
      service.model
    })
  end
end
