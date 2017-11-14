module Services
  class RetrieveSaltedgeAccounts
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

    attr_reader :saltedge_account

    def call
      response = @saltedge_client.request(:get, "/accounts", {
        login_id: @saltedge_login.saltedge_id
      })
      data = JSON.parse(response.body)
      accounts = data["data"].select do |a|
        SaltedgeAccount::ACCOUNT_NATURE_WHITELIST.include?(a["nature"])
      end
      accounts.each do |account_data|
        if saltedge_account = SaltedgeAccount.find_by(saltedge_id: account_data["id"])
          Services::UpdateSaltedgeAccount.new(saltedge_account, account_data: account_data).call
        else
          begin
            @saltedge_login.user.saltedge_accounts.create!(
              saltedge_login: @saltedge_login,
              saltedge_id: account_data["id"],
              saltedge_data: account_data,
              selected: false
            )
          rescue ActiveRecord::RecordNotUnique
            nil
          end
        end
      end
    end
  end
end
