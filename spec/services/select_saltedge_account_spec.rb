require 'spec_helper'

RSpec.describe Services::SelectSaltedgeAccount do
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

  it "creates a saltedge account and a correspondant virtual account for the user" do
    service = Services::SelectSaltedgeAccount.new(saltedge_login)
    expect { service.call }.to change{ user.saltedge_accounts.count + user.virtual_accounts.count }.by(2)
    last_saltedge_account = user.saltedge_accounts.last
    expect(last_saltedge_account.saltedge_data).to_not be_empty
    expect(last_saltedge_account.virtual_account).to_not be nil
  end

  it "doesn't save anything if saltedge account or virtual account creation fails" do
    allow_any_instance_of(VirtualAccountForm).to receive(:valid?).and_return(false)
    service = Services::SelectSaltedgeAccount.new(saltedge_login)
    expect {
      begin
        service.call
      rescue Exception => e
        nil
      end }.not_to change{ user.saltedge_accounts.count + user.virtual_accounts.count }
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
    service = Services::SelectSaltedgeAccount.new(saltedge_login)
    expect { service.call }.to change{ user.saltedge_accounts.count }.by(0)
  end
end
