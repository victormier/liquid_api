require 'spec_helper'

RSpec.describe "/login" do
  before {
    User.create(email: "johndoe@example.com", password: "password")
  }

  it "allows logging in with valid data" do
    params = {
      email: "johndoe@example.com",
      password: "password"
    }
    post "/login", params.to_json

    expect(last_response.ok?).to be true
    expect(JSON.parse(last_response.body).keys).to include("auth_token")
  end

  it "returns :unauthorized with non existing user" do
    params = {
      email: "false@example.com",
      password: "password"
    }
    post "/login", params.to_json

    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
  end

  it "returns :unauthorized with wrong password" do
    params = {
      email: "johndoe@example.com",
      password: "badpassword"
    }
    post "/login", params.to_json

    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
  end
end
