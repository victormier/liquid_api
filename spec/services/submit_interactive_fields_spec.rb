require 'spec_helper'

RSpec.describe Services::SubmitInteractiveFields do
  let(:user) { create(:user, saltedge_id: "123456") }
  let(:saltedge_login) { create(:saltedge_login, user: user) }
  let(:interactive_fields_submit_response) { File.read('spec/support/fixtures/interactive_fields_submit_response.json') }

  before do
    # Stub saltedge customer creation
    stub_request(:post, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}/interactive").
      to_return(
        body: interactive_fields_submit_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "submits interactive credentials to saltedge" do
    service = Services::SubmitInteractiveFields.new(
      user,
      saltedge_login,
      { "sms": "12345" }
    )
    expect(service.call).to have_requested(:post, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}/interactive")
  end
end
