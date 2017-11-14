require 'spec_helper'

RSpec.describe Services::UpdateSaltedgeAccount do
  let(:user) { create(:user, saltedge_id: "12345") }
  let(:saltedge_account) { create(:saltedge_account, user: user) }
  let(:saltedge_accounts_list_response) {
    f = File.read('spec/support/fixtures/saltedge_accounts_list_response.json')
    account_data = JSON.parse(f)
    account_data["data"][0]["id"] = saltedge_account.saltedge_id.to_i
    account_data["data"][0]["balance"] = 3000
    account_data.to_json
  }

  before do
    # Stub saltedge account listing
    stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
      to_return(
        body: saltedge_accounts_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "updates the data about a saltedge account" do
    service = Services::UpdateSaltedgeAccount.new(saltedge_account)
    service.call
    expect(saltedge_account.saltedge_data).to eq JSON.parse(saltedge_accounts_list_response)["data"][0]
  end

  describe "when there's a related virtual account" do
    let(:saltedge_account) { create(:saltedge_account, :with_virtual_account, user: user)}

    it "creates a job for retrieving all transactions of that account" do
      Sidekiq::Testing.fake! do
        service = Services::UpdateSaltedgeAccount.new(saltedge_account)
        expect {
          service.call
        }.to change(LoadTransactionsWorker.jobs, :size).by(1)
      end
    end

    it "recalculates balance of virtual account" do
      Sidekiq::Testing.fake! do
        service = Services::UpdateSaltedgeAccount.new(saltedge_account)
        service.call
        expect(saltedge_account.virtual_account.balance).to eq(3000)
      end
    end
  end

  describe "when there's no related virtual account" do
    it "doesn't create any job" do
      Sidekiq::Testing.fake! do
        service = Services::UpdateSaltedgeAccount.new(saltedge_account)
        expect {
          service.call
        }.to change(LoadTransactionsWorker.jobs, :size).by(0)
      end
    end
  end

  it "stores account_data paramater if it is passed" do
    account_data = JSON.parse(saltedge_accounts_list_response)["data"][0]
    account_data["balance"] = 1234.5
    Services::UpdateSaltedgeAccount.new(saltedge_account, account_data: account_data).call
    expect(saltedge_account.balance).to eq 1234.5
  end
end
