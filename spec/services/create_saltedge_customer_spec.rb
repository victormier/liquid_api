require 'spec_helper'

RSpec.describe Services::CreateSaltedgeCustomer do
  let(:user) {
    User.create(email: "johndoe@example.com",
                        password: "password")
  }
  subject { Services::CreateSaltedgeCustomer.new(user)  }

  before do
    stub_request(:post, "https://www.saltedge.com/api/v3/customers").
     to_return(
       body: {
          "data": {
            "id":         18892,
            "identifier": "12rv1212f1efxchsdhbgv",
            "secret":     "AtQX6Q8vRyMrPjUVtW7J_O1n06qYQ25bvUJ8CIC80-8"
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "creates a customer in saltedge" do
    subject.call
    expect(user.saltedge_id).to eq "18892"
    expect(user.saltedge_customer_secret).to eq "AtQX6Q8vRyMrPjUVtW7J_O1n06qYQ25bvUJ8CIC80-8"
    expect(user.saltedge_custom_identifier).to_not be nil
  end

end
