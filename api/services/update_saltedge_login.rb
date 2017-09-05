module Services
  class UpdateSaltedgeLogin
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

    def call
      response = @saltedge_client.request(:get, "/logins/#{@saltedge_login.saltedge_id}")
      data = JSON.parse(response.body)

      @saltedge_client.update_attributes({
        saltedge_data: response["data"]
      })
    end
  end
end
