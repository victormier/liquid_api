module Mutations
  UpdateMirrorAccount = GraphQL::Field.define do
    name "updateMirrorAccount"
    description "Tries to update the data of a mirror account"
    # Saltedge Login status should be updated on client as it
    # is likely to change after this service is run

    type VirtualAccountType

    argument :mirror_account_id, !types.ID

    resolve GraphqlRescueFrom.new(LiquidApi::MutationInvalid, ->(t, args, ctx) {
      mirror_account = ctx[:current_user].virtual_accounts.mirror.find(args[:mirror_account_id])

      if mirror_account.saltedge_account.can_be_refreshed?
        saltedge_login = mirror_account.saltedge_account.saltedge_login
        begin
          # Request a data refresh on saltedge side
          Services::RefreshSaltedgeLogin.new(saltedge_login).call
        rescue RestClient::NotAcceptable => e
          # refresh probably can't be accepted
          Services::UpdateSaltedgeLogin.new(saltedge_login).call
          # raise if the NotAcceptable is not caused because it couldn't be refreshed
          raise e if saltedge_login.reload.can_be_refreshed?
        end
      end

      # Update account anyway with latest saltedge data
      # If there's a data refresh, once more data becomes
      # available after the refresh, callbacks will update the data
      service = Services::UpdateSaltedgeAccount.new(mirror_account.saltedge_account)
      service.call
      mirror_account.reload
    })
  end
end
