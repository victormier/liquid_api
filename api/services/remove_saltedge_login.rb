module Services
  class RemoveSaltedgeLogin
    def initialize(saltedge_login)
      @saltedge_login = saltedge_login
      @saltedge_client = SaltedgeClient.new
    end

    def call
      response = @saltedge_client.request(:delete, "/logins/#{@saltedge_login.saltedge_id}")

      if response.code == 200
        @saltedge_login.kill
      end
    end
  end
end
