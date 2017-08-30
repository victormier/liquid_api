module Services
  class CreateSaltedgeCustomer
    def initialize(user)
      @user = user
    end

    def call
      custom_identifier = "#{@user.id}-#{SecureRandom.hex(5)}"

      begin
        response = SaltedgeClient.new.request(:post, "/customers", {
          data: {
            identifier: custom_identifier
          }
        })
        data = JSON.parse(response.body)
      # Saltedge Identifier already exists in Saltedge (most likely )
      rescue RestClient::Conflict => e
        # if(JSON.parse(e.response)["error_class"] == "DuplicatedCustomer")
        #   # To Do: Find saltedge_id, request customers/show and store customer_secret
        # end
        raise e
      end

      if(data && data.keys.include?("data"))
        @user.update_attributes({
          saltedge_id: data["data"]["id"],
          saltedge_custom_identifier: custom_identifier,
          saltedge_customer_secret: data["data"]["secret"]
        })
      end
    end
  end
end
