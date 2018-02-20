module Mutations
  SubmitInteractiveFields = GraphQL::Field.define do
    name "submitInteractiveFields"
    description "Submits interactive fields for a login attempt"
    type SaltedgeLoginType

    argument :saltedgeLoginId, !types.ID
    argument :credentials, !types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      @saltedge_login = ctx[:current_user].saltedge_logins.find(args[:saltedgeLoginId])
      credentials = args[:credentials].is_a?(Hash) ? args[:credentials] : JSON.parse(args[:credentials])
      service = Services::SubmitInteractiveFields.new(ctx[:current_user], @saltedge_login, credentials)
      if service.call
        service.saltedge_login
      end
    })
  end
end
