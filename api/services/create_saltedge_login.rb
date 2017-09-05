module Services
  class CreateSaltedgeLogin
    attr_reader :saltedge_login

    def initialize(user,
      saltedge_provider, credentials)
      @saltedge_client = SaltedgeClient.new
      @user = user
      @saltedge_provider = saltedge_provider
      @credentials = credentials
    end

    def call
      # if user doesn't exist on saltedge, create user
      unless @user.is_saltedge_customer?
        Services::CreateSaltedgeCustomer.new(@user).call
      end
      # create login on saltedge
      params = {
        data: {
          customer_id: @user.saltedge_id.to_i,
          country_code: @saltedge_provider.country_code,
          provider_code: @saltedge_provider.saltedge_data["code"],
          daily_refresh: true,
          credentials: @credentials
        }
      }

      response = @saltedge_client.request(:post, "/logins", params)

      # store login on app
      data = JSON.parse(response.body)
      @saltedge_login = @user.saltedge_logins.create(
        saltedge_id: data["data"]["id"],
        saltedge_data: data["data"],
        saltedge_provider_id: @saltedge_provider.id
      )
    end
  end
end
