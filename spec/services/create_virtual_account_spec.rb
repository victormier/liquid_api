require 'spec_helper'

RSpec.describe Services::CreateVirtualAccount do
  let(:user) { create(:user) }
  let(:saltedge_account) { create(:saltedge_account, user: user) }
  subject { Services::CreateVirtualAccount.new(user, { name: "Test Account" })  }
  before { saltedge_account }

  it "creates a customer in saltedge" do
    expect { subject.call }.to change{ user.virtual_accounts.count }.by(1)
    expect(subject.model.currency_code).to eq(saltedge_account.currency_code)
  end

  it "fails if validation fails" do
    params = {
      name: "Account",
      currency_code: "invalid_code"
    }
    service = Services::CreateVirtualAccount.new(user, params)
    expect(service.call).to be false
  end

  it "fails if user has no saltedge_account" do
    user.saltedge_accounts.destroy_all
    expect{ subject.call }.to raise_exception(LiquidApi::MutationInvalid)
  end
end
