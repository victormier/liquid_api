module Services
  class UpdateSaltedgeLogin
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

    def call
      response = @saltedge_client.request(:get, "/logins/#{@saltedge_login.saltedge_id}")
      data = JSON.parse(response.body)

      @saltedge_login.update_attributes({
        saltedge_data: data["data"]
      })
    end
  end
end
