module Mutations
  CreateSaltedgeLogin = GraphQL::Field.define do
    name "createSaltedgeLogin"
    description "Creates a new SaltedgeLogin (bank connection)"
    type SaltedgeLoginType

    argument :saltedgeProviderId, !types.ID
    argument :credentials, !types.String

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      @saltedge_provider = SaltedgeProvider.find(args[:saltedgeProviderId])
      credentials = args[:credentials].is_a?(Hash) ? args[:credentials] : JSON.parse(args[:credentials])
      service = Services::CreateSaltedgeLogin.new(ctx[:current_user], @saltedge_provider, credentials)

      if service.call
        service.saltedge_login
      end
    })
  end
end
