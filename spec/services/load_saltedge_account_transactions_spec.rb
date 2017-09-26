require 'spec_helper'

RSpec.describe Services::LoadSaltedgeAccountTransactions do
  let(:user) { create(:user, saltedge_id: "12345") }
  let(:saltedge_login) { create(:saltedge_login, user: user) }
  let(:saltedge_account) { create(:saltedge_account, saltedge_login: saltedge_login) }
  let(:saltedge_accounts_list_response) { File.read('spec/support/fixtures/saltedge_accounts_list_response.json') }
  let(:saltedge_transactions_list_response) { File.read('spec/support/fixtures/saltedge_transactions_list_response.json') }

  before do
    # Stub saltedge account listing
    stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
      to_return(
        body: saltedge_accounts_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Stub saltedge transaction list
    stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      to_return(
        body: saltedge_transactions_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "downloads and stores saltedge transactions for a user account" do
    service = Services::LoadSaltedgeAccountTransactions.new(saltedge_account)
    expect { service.call }.to change{ saltedge_account.saltedge_transactions.count + saltedge_account.virtual_account.transactions.count }.by(4)
  end

  it "loads data from last 3 months on the first pull"


  describe "when there's multiple pages" do
    before do
      stub_response = JSON.parse(saltedge_transactions_list_response)
      stub_response["meta"]["next_id"] = "123"

      stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      with(body: {
        account_id: saltedge_account.saltedge_id,
      }.to_json).
      to_return(
      body: stub_response.to_json,
      headers: { 'Content-Type' => 'application/json' }
      )

      stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      with(body: {
        account_id: saltedge_account.saltedge_id,
        from_id: "123"
      }.to_json).
      to_return(
      body: saltedge_transactions_list_response,
      headers: { 'Content-Type' => 'application/json' }
      )

    end

    it "loads multiple pages properly" do
      service = Services::LoadSaltedgeAccountTransactions.new(saltedge_account)
      expect { service.call }.to change{ saltedge_account.saltedge_transactions.count }.by(4)
    end
  end
end
