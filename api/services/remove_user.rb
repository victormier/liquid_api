module Services
  class RemoveUser
    def initialize(user)
      @user = user
    end

    def call
      User.transaction do
        # remove remote saltedge user and all its data
        Services::RemoveSaltedgeCustomer.new(@user).call

        # removes saltedge logins
        #   removes saltedge accounts
        #     removes saltedge transactions
        # remove user record
        #   removes virtual accounts
        #     removes transactions
        # removes rules
        @user.destroy
      end
    end
  end
end
