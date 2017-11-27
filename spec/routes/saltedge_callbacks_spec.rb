require 'spec_helper'

RSpec.describe "/saltedge_callbacks" do
  let(:saltedge_login) { create(:saltedge_login) }
  let(:saltedge_account) { create(:saltedge_account, saltedge_login: saltedge_login)}
  let(:time_string) { Time.now.to_s }
  let(:saltedge_login_response) {
    response = JSON.parse(File.read('spec/support/fixtures/saltedge_login_create_response.json'))
    response["data"]["last_success_at"] = time_string
    response.to_json
  }
  let(:saltedge_success_callback_body) {
    response = JSON.parse(File.read('spec/support/fixtures/saltedge_callback_success.json'))
    response["data"]["login_id"] = saltedge_login.saltedge_id
    response.to_json
  }
  let(:saltedge_failure_callback_body) {
    response = JSON.parse(File.read('spec/support/fixtures/saltedge_callback_failure.json'))
    response["data"]["login_id"] = saltedge_login.saltedge_id
    response.to_json
  }
  let(:saltedge_accounts_list_response) { File.read('spec/support/fixtures/saltedge_accounts_list_response.json') }

  before do
    # Stub saltedge login creation
    stub_request(:get, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}").
    to_return(
      body: saltedge_login_response,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  context "/success" do
    before do
      # Stub saltedge account listing
      stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
      to_return(
        body: saltedge_accounts_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "updates data about a login" do
      saltedge_login
      post "saltedge_callbacks/success", saltedge_success_callback_body
      expect(saltedge_login.reload.saltedge_data["last_success_at"]).to eq time_string
    end

    it "updates saltedge_accounts that belong to the login" do
      saltedge_account
      Sidekiq::Testing.fake! do
        expect {
          post "saltedge_callbacks/success", saltedge_success_callback_body
        }.to change{ UpdateSaltedgeAccountWorker.jobs.size }.by(1)
      end
    end

    it "loads transactions for each saltedge_account that belong to the login"

    it "doesn't do anything if saltedge_login doesn't exist"

    it "returns 200 on success"
  end

  context "/failure" do
    it "updates data about a login" do
      saltedge_login
      post "saltedge_callbacks/failure", saltedge_failure_callback_body
      expect(saltedge_login.reload.saltedge_data["last_success_at"]).to eq time_string
    end

    it ""
  end
end
