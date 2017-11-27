module Services
  class RefreshSaltedgeLogin
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

    def call
      refresh_requested_at = DateTime.now
      response = @saltedge_client.request(:put, "/logins/#{@saltedge_login.saltedge_id}/refresh")
      data = JSON.parse(response.body)
      @saltedge_login.update_attributes({
        saltedge_data: data["data"],
        last_refresh_requested_at: refresh_requested_at
      })
    end
  end
end
