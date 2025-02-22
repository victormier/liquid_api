require 'spec_helper'

RSpec.describe Services::SelectSaltedgeAccount do
  let(:user) { create(:user, saltedge_id: "12345") }
  let(:saltedge_account) { create(:saltedge_account, user: user) }
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

  it "updates the saltedge account with selected: true" do
    service = Services::SelectSaltedgeAccount.new(user, saltedge_account.id)
    service.call
    expect(saltedge_account.reload.selected).to be true
  end

  it "creates a virtual account" do
    service = Services::SelectSaltedgeAccount.new(user, saltedge_account.id)
    expect { service.call }.to change{ user.virtual_accounts.mirror.count }.by(1)
    expect(saltedge_account.virtual_account).to_not be nil
  end

  it "doesn't save anything if saltedge account or virtual account creation fails" do
    allow_any_instance_of(VirtualAccountForm).to receive(:valid?).and_return(false)
    service = Services::SelectSaltedgeAccount.new(user, saltedge_account.id)
    expect {
      begin
        service.call
      rescue Exception => e
        nil
      end }.not_to change{ user.virtual_accounts.count }
    expect(saltedge_account.reload.selected).to be false
  end
end
