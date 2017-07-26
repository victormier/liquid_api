require 'spec_helper'

RSpec.describe "/login" do
  let(:user) { User.create(email: "johndoe@example.com", password: "password") }
  before { user.mark_as_confirmed! }

  def logged_in_auth_token
    post "/login", params = {
      email: "johndoe@example.com",
      password: "password"
    }.to_json
    expect(last_response.ok?).to be true
    JSON.parse(last_response.body)["auth_token"]
  end

  it "allows logging in with valid data" do
    params = {
      email: "johndoe@example.com",
      password: "password"
    }
    post "/login", params.to_json

    json_response = JSON.parse(last_response.body)
    expect(last_response.ok?).to be true
    expect(json_response.keys).to include("auth_token")
    expect(json_response["user_id"]).to eq user.id
  end

  it "allows case insensitive logging in" do
    params = {
      email: "johnDOe@ExAMple.com",
      password: "password"
    }
    post "/login", params.to_json

    json_response = JSON.parse(last_response.body)
    expect(last_response.ok?).to be true
    expect(json_response.keys).to include("auth_token")
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

  it "returns :unauthorized if no params" do
    post "/login", params = {}.to_json

    expected_body = {
      'errors' => [
        'Email must be filled',
        'Password must be filled'
      ]
    }
    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
    expect(JSON.parse(last_response.body)).to eq expected_body
  end

  it "returns :unauthorized if user not confirmed" do
    allow_any_instance_of(User).to receive(:confirmed?).and_return(false)

    params = {
      email: "johndoe@example.com",
      password: "password"
    }
    post "/login", params.to_json

    expected_body = {
      'errors' => [
        'Email is not confirmed',
      ]
    }
    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
    expect(JSON.parse(last_response.body)).to eq expected_body
  end
end

RSpec.describe "Token authentication" do
  before {
    user = User.create(email: "johndoe@example.com", password: "password", id: 55)
    user.mark_as_confirmed!
  }

  def logged_in_auth_token
    post "/login", params = {
      email: "johndoe@example.com",
      password: "password"
    }.to_json
    expect(last_response.ok?).to be true
    JSON.parse(last_response.body)["auth_token"]
  end

  it "authenticates a logged in request" do
    token = logged_in_auth_token
    header "Authorization", "Bearer #{token}"
    post "/graphql", {query: "{}" }.to_json

    expect(last_response.ok?).to be true
  end

  it "returns :unauthorized if user doesn't exist" do
    data = { user_id: 0 }
    token = Rack::JWT::Token.encode(data, ENV['RACK_JWT_SECRET'], 'HS256')
    header "Authorization", "Bearer #{token}"
    post "/graphql", {query: "{}" }.to_json

    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
  end

  it "returns :unauthorized if token is not valid" do
    header "Authorization", "Bearer loremipsum012345"
    post "/graphql", {query: "{}" }.to_json

    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
  end

  it "returns :unauthorized if email is not confirmed" do
    token = logged_in_auth_token
    header "Authorization", "Bearer #{token}"
    allow_any_instance_of(User).to receive(:confirmed?).and_return(false)
    post "/graphql", {query: "{}" }.to_json

    expect(last_response.status).to eq Rack::Utils.status_code(:unauthorized)
  end
end
