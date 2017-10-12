require 'spec_helper'

RSpec.describe Services::RetrieveSaltedgeAccounts do
  let(:user) { create(:user, saltedge_id: "12345") }
  let(:saltedge_login) { create(:saltedge_login, user: user) }
  let(:saltedge_accounts_list_response) { File.read('spec/support/fixtures/saltedge_accounts_list_response.json') }

  before do
    # Stub saltedge account listing
    stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
      to_return(
        body: saltedge_accounts_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "creates a saltedge account record for each account found" do
    service = Services::RetrieveSaltedgeAccounts.new(saltedge_login)
    expect { service.call }.to change{ user.saltedge_accounts.count }.by(2)
    last_saltedge_account = user.saltedge_accounts.last
    expect(last_saltedge_account.saltedge_data).to_not be_empty
  end

  it "only selects whitelisted nature accounts" do
    response_without_whitelisted_nature = begin
      account_data = JSON.parse(saltedge_accounts_list_response)
      account_data["data"].select do |a|
        !SaltedgeAccount::ACCOUNT_NATURE_WHITELIST.include?(a["nature"])
      end
    end
    stub_request(:get, "https://www.saltedge.com/api/v3/accounts").
      to_return(
        body: { "data" => response_without_whitelisted_nature}.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    service = Services::RetrieveSaltedgeAccounts.new(saltedge_login)
    expect { service.call }.to change{ user.saltedge_accounts.count }.by(0)
  end
end
