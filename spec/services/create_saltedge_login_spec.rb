require 'spec_helper'

RSpec.describe Services::CreateSaltedgeLogin do
  let(:user) {
    User.create(email: "johndoe@example.com",
                        password: "password")
  }
  let(:saltedge_provider) { create(:saltedge_provider) }
  let(:saltedge_login_create_response) { File.read('spec/support/fixtures/saltedge_login_create_response.json') }

  before do
    # Stub saltedge customer creation
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
    # Stub saltedge login creation
    stub_request(:post, "https://www.saltedge.com/api/v3/logins").
      to_return(
        body: saltedge_login_create_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "creates a login in saltedge and stores it as a new saltedge_login" do
    service = Services::CreateSaltedgeLogin.new(
      user,
      saltedge_provider,
      {
        "user": "12345",
        "password": "lamepassword"
      }
    )
    expect { service.call }.to change{ user.saltedge_logins.count }.by(1)
    new_saltedge_login = user.saltedge_logins.last
    expect(new_saltedge_login.saltedge_id).to eq "1227"
    expect(new_saltedge_login.saltedge_data).to eq JSON.parse(saltedge_login_create_response)["data"]
  end

  it "creates a saltedge customer if user doesn't have one"

end
