require 'spec_helper'

RSpec.describe Services::CreateVirtualTransaction do
  let(:user) { create(:user) }
  let(:origin_account) { create(:virtual_account, user: user) }
  let(:destination_account) { create(:virtual_account, user: user) }
  let(:params) {
    {
      amount: 10,
      origin_account_id: origin_account.id,
      destination_account_id: destination_account.id
    }
  }
  subject { Services::CreateVirtualTransaction.new(user, params)  }

  it "creates a virtual transaction" do
    expect { subject.call }.to change{ origin_account.transactions.count + origin_account.transactions.count }.by(2)
  end

  it "updates balance for origin account" do
    # make sure balance is right
    origin_account.compute_balance!
    expect { subject.call }.to change{ origin_account.reload.balance }.by(-params[:amount])
  end

  it "updates balance for destination account" do
    # make sure balance is right
    destination_account.compute_balance!
    expect { subject.call }.to change{ destination_account.reload.balance }.by(params[:amount])
  end

  it "fails if validation fails" do
    origin_account.update_attributes(balance: 5.0)
    service = Services::CreateVirtualTransaction.new(user, params)
    expect{ service.call }.to raise_exception(LiquidApi::MutationInvalid)
  end

  it "doesn't save any transaction if one of them fails (it's a double entry system)" do
    destination_account.update_attributes(currency_code: "EUR")
    service = Services::CreateVirtualTransaction.new(user, params)
    expect {
      begin
        service.call
      rescue Exception => e
        nil
      end
    }.to_not change{ Transaction.count }
  end
end
