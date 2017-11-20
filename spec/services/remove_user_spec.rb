require 'spec_helper'

RSpec.describe Services::RemoveUser do
  let(:user) {
    create(:user, :with_mirror_account, saltedge_id: "12345").tap do |user|
      create(:percentage_rule, destination_virtual_account: user.default_mirror_account)
      create_list(:saltedge_transaction, 2, saltedge_account: user.default_saltedge_account)
      create_list(:virtual_transaction, 2, virtual_account: user.default_mirror_account)
    end
  }
  let(:subject) {Services::RemoveUser.new(user) }
  # saltedge account
  # mirror account
  # saltedge login
  # rules
  # saltedge transactions
  # virtual transactions

  # let(:saltedge_login_create_response) { File.read('spec/support/fixtures/saltedge_login_create_response.json') }

  before do
    # # Stub saltedge customer creation
    # stub_request(:post, "https://www.saltedge.com/api/v3/customers").
    #  to_return(
    #    body: {
    #       "data": {
    #         "id":         18892,
    #         "identifier": "12rv1212f1efxchsdhbgv",
    #         "secret":     "AtQX6Q8vRyMrPjUVtW7J_O1n06qYQ25bvUJ8CIC80-8"
    #       }
    #     }.to_json,
    #     headers: { 'Content-Type' => 'application/json' }
    #   )

    # Stub saltedge customer delete
    stub_request(:delete, "https://www.saltedge.com/api/v3/customers/#{user.saltedge_id}").
      to_return(status: 200)
  end

  it "calls saltedge api for user removal" do
    expect(subject.call).to have_requested(:delete, "https://www.saltedge.com/api/v3/customers/#{user.saltedge_id}")
  end

  it "destroys saltedge logins" do
    saltedge_logins = user.saltedge_logins
    expect{ subject.call }.to change { saltedge_logins.count }.from(1).to(0)
  end

  it "destroys saltedge accounts" do
    saltedge_accounts = user.saltedge_accounts
    expect{ subject.call }.to change { saltedge_accounts.count }.from(1).to(0)
  end

  it "destroys saltedge transactions" do
    saltedge_transaction_ids = user.saltedge_accounts.map{ |sa| sa.saltedge_transactions.map(&:id) }.flatten
    expect{ subject.call }.to change { SaltedgeTransaction.where(id: saltedge_transaction_ids).count }.from(2).to(0)
  end

  it "destroys virtual accounts" do
    virtual_accounts = user.virtual_accounts
    expect{ subject.call }.to change { virtual_accounts.count }.from(1).to(0)
  end

  it "destroys virtual accounts" do
    virtual_accounts = user.virtual_accounts
    expect{ subject.call }.to change { virtual_accounts.count }.from(1).to(0)
  end

  it "destroys the user itself" do
    subject.call
    expect{ user.reload }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
