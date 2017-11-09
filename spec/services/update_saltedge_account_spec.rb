require 'spec_helper'

RSpec.describe Services::UpdateSaltedgeAccount do
  Sidekiq::Testing.fake!

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
      service = Services::UpdateSaltedgeAccount.new(saltedge_account)
      expect {
        service.call
      }.to change(LoadTransactionsWorker.jobs, :size).by(1)
    end

    it "recalculates balance of virtual account" do
      service = Services::UpdateSaltedgeAccount.new(saltedge_account)
      service.call
      expect(saltedge_account.virtual_account.balance).to eq(3000)
    end
  end

  describe "when there's no related virtual account" do
    it "doesn't create any job" do
      service = Services::UpdateSaltedgeAccount.new(saltedge_account)
      expect {
        service.call
      }.to change(LoadTransactionsWorker.jobs, :size).by(0)
    end
  end
  #
  # it "creates a saltedge account record for each account found" do
  #   service = Services::UpdateSaltedgeAccount.new(saltedge_login)
  #   expect { service.call }.to change{ user.saltedge_accounts.count }.by(2)
  #   last_saltedge_account = user.saltedge_accounts.last
  #   expect(last_saltedge_account.saltedge_data).to_not be_empty
  # end
  #
  # it "doesn't create new records if account exists" do
  #   service = Services::UpdateSaltedgeAccount.new(saltedge_login)
  #   expect { service.call }.to change{ user.saltedge_accounts.count }.by(2)
  #   new_service = Services::UpdateSaltedgeAccount.new(saltedge_login)
  #   expect { new_service.call }.to change{ user.saltedge_accounts.count }.by(0)
  # end
  #
  # it "only selects whitelisted nature accounts" do
  #   response_without_whitelisted_nature = begin
  #     account_data = JSON.parse(saltedge_accounts_list_response)
  #     account_data["data"].select do |a|
  #       !SaltedgeAccount::ACCOUNT_NATURE_WHITELIST.include?(a["nature"])
  #     end
  #   end
  #   stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
  #     to_return(
  #       body: { "data" => response_without_whitelisted_nature}.to_json,
  #       headers: { 'Content-Type' => 'application/json' }
  #     )
  #   service = Services::UpdateSaltedgeAccount.new(saltedge_login)
  #   expect { service.call }.to change{ user.saltedge_accounts.count }.by(0)
  # end
end
