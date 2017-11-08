QueryRoot = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :user do
    type UserType
    resolve -> (obj, args, ctx) { ctx[:current_user] }
  end

  field :all_users do
    type types[!UserType]
    resolve -> (obj, args, ctx) { User.all }
  end

  field :saltedge_provider do
    type SaltedgeProviderType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { SaltedgeProvider.automatically_fetchable.find(args["id"]) }
  end

  field :all_saltedge_providers do
    type types[!SaltedgeProviderType]
    resolve -> (obj, args, ctx) {
      SaltedgeProvider.selectable
    }
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

  field :insights do
    type InsightsType
    argument :month, !types.Int
    argument :year, !types.Int

    resolve -> (obj, args, ctx) {
      start_date = Date.new(args[:year], args[:month], 1)
      end_date = Date.new(args[:year], args[:month], -1)
      Insights.new(ctx[:current_user], start_date, end_date)
    }
  end

  field :all_insights do
    type types[!InsightsType]

    resolve -> (obj, args, ctx) {
      Insights.all_monthly(ctx[:current_user])
    }
  end

  field :percentage_rule do
    type PercentageRuleType

    resolve -> (obj, args, ctx) {
      PercentageRule.where(user: ctx[:current_user]).first
    }
  end

  field :all_saltedge_accounts do
    type types[!SaltedgeAccountType]

    resolve -> (obj, args, ctx) {
      ctx[:current_user].saltedge_accounts
    }
  end
end

MutationRoot = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The mutation root of this schema'

  field :registerUser, field: Mutations::RegisterUser
  field :createSaltedgeLogin, field: Mutations::CreateSaltedgeLogin
  field :createVirtualAccount, field: Mutations::CreateVirtualAccount
  field :createVirtualTransaction, field: Mutations::CreateVirtualTransaction
  field :updatePercentageRule, field: Mutations::UpdatePercentageRule
  field :selectSaltedgeAccount, field: Mutations::SelectSaltedgeAccount
end

Schema = GraphQL::Schema.define do
  query QueryRoot
  mutation MutationRoot

  orphan_types [SaltedgeAccountType]

  resolve_type ->(obj, ctx) {
    Schema.types[obj.class.name]
  }
end
