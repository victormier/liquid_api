require 'spec_helper'

RSpec.describe Mutations::CreateSaltedgeLogin do
  let(:user) { create(:user, saltedge_id: "123456") }
  let(:saltedge_provider) { create(:saltedge_provider) }
  let(:subject) { Schema.types["Mutation"].fields["createSaltedgeLogin"] }
  let(:saltedge_login_create_response) { File.read('spec/support/fixtures/saltedge_login_create_response.json') }
  let(:args) {{
    "saltedgeProviderId": saltedge_provider.id,
    "credentials": {
      "user": "fakeuser",
      "password": "fakepassword"
    }.to_json
  }}

  before do
    stub_request(:post, "https://www.saltedge.com/api/v3/logins").
      to_return(
        body: saltedge_login_create_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "creates a new login with valid data" do
    expect { subject.resolve(nil, args, { current_user: user }) }.to change{ user.saltedge_logins.count }.by(1)
  end

  it "raises an exception if api call fails"
end
