module Services
  class SubmitInteractiveFields
    attr_reader :saltedge_login

    def initialize(user, saltedge_login, credentials)
      @saltedge_client = SaltedgeClient.new
      @user = user
      @saltedge_login = saltedge_login
      @credentials = credentials
    end

    def call
      params = {
        data: {
          credentials: @credentials
        }
      }
      response = @saltedge_client.request(:put, "/logins/#{@saltedge_login.saltedge_id}/interactive", params)
      data = JSON.parse(response.body)
      @saltedge_login.update_attributes(
        saltedge_data: data["data"]
      )
    end
  end
end
