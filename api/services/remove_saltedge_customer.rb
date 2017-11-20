module Services
  class RemoveSaltedgeCustomer
    def initialize(user)
      @user = user
      @saltedge_client = SaltedgeClient.new
    end

    def call
      response = @saltedge_client.request(:delete, "/customers/#{@user.saltedge_id}")
    end
  end
end
