require 'spec_helper'

RSpec.describe Mutations::SubmitInteractiveFields do
  let(:user) { create(:user, saltedge_id: "123456") }
  let(:saltedge_login) { create(:saltedge_login, user: user) }
  let(:subject) { Schema.types["Mutation"].fields["submitInteractiveFields"] }
  let(:interactive_fields_submit_response) { File.read('spec/support/fixtures/interactive_fields_submit_response.json') }
  let(:args) {{
    "saltedgeLoginId": saltedge_login.id,
    "credentials": {
      "sms": "12345"
    }.to_json
  }}

  before do
    stub_request(:post, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}/interactive").
      to_return(
        body: interactive_fields_submit_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "calls SubmitInteractiveFields service" do
    expect_any_instance_of(Services::SubmitInteractiveFields).to receive(:call)
    subject.resolve(nil, args, { current_user: user })
  end

  it "returns the saltedge login" do
    expect(subject.resolve(nil, args, { current_user: user })).to eq saltedge_login
  end
end
