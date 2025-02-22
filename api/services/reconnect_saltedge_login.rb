module Services
  class ReconnectSaltedgeLogin
    attr_reader :saltedge_login

    def initialize(saltedge_login, credentials)
      @saltedge_client = SaltedgeClient.new
      @saltedge_login = saltedge_login
      @credentials = credentials
    end

    def call
      params = {
        data: {
          credentials: @credentials,
          daily_refresh: true
        }
      }
      response = @saltedge_client.request(:put, "/logins/#{@saltedge_login.saltedge_id}/reconnect", params)
      data = JSON.parse(response.body)
      @saltedge_login.update_attributes({
        saltedge_data: data["data"]
      })
    end
  end
end
