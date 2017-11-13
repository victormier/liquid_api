module Mutations
  ReconnectSaltedgeLogin = GraphQL::Field.define do
    name "reconnectSaltedgeLogin"
    description "Reconnects a SaltedgeLogin with new credentials"
    type SaltedgeLoginType

    argument :saltedgeLoginId, !types.ID
    argument :credentials, !types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      @saltedge_login = ctx[:current_user].saltedge_logins.find(args[:saltedgeLoginId])
      credentials = args[:credentials].is_a?(Hash) ? args[:credentials] : JSON.parse(args[:credentials])
      service = Services::ReconnectSaltedgeLogin.new(@saltedge_login, credentials)

      if service.call
        service.saltedge_login
      end
    })
  end
end
