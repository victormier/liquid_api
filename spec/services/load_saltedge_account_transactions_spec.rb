require 'spec_helper'

RSpec.describe Services::LoadSaltedgeAccountTransactions do
  let(:user) { create(:user, :with_mirror_account, saltedge_id: "12345") }
  let(:saltedge_account) { user.default_mirror_account.saltedge_account }
  let(:saltedge_login) { saltedge_account.saltedge_login }
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

  it "creates automatic transactions when needed" do
    # load transactions stubbed request returns a 50€ income transaction
    dest_virtual_account = create(:virtual_account, user: user)
    create(:percentage_rule,
            user: user,
            destination_virtual_account: dest_virtual_account,
            config: {
              minimum_amount: 50.0,
              percentage: 10
            }
    )
    service = Services::LoadSaltedgeAccountTransactions.new(saltedge_account)
    expect { service.call }.to change {
      saltedge_account.virtual_account.transactions.automatic.count + dest_virtual_account.transactions.automatic.count
    }.by(2)
  end

  it "loads data from last 3 months on the first pull"

  it "computes balance after transactions are created" do
    new_balance = 2012.7 # based on saltedge accounts' balance / what's returned by the api
    create(:virtual_transaction, virtual_account: user.default_mirror_account, amount: -100)
    service = Services::LoadSaltedgeAccountTransactions.new(saltedge_account)
    service.call
    expect(user.default_mirror_account.reload.balance).to eq (new_balance - 100.0)
  end


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

      second_stub_response = JSON.parse(saltedge_transactions_list_response)
      second_stub_response["data"][0]["id"] = 989
      second_stub_response["data"][1]["id"] = 990
      stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      with(body: {
        account_id: saltedge_account.saltedge_id,
        from_id: "123"
      }.to_json).
      to_return(
      body: second_stub_response.to_json,
      headers: { 'Content-Type' => 'application/json' }
      )

    end

    it "loads multiple pages properly" do
      service = Services::LoadSaltedgeAccountTransactions.new(saltedge_account)
      expect { service.call }.to change{ saltedge_account.saltedge_transactions.count }.by(4)
    end
  end
end
