require 'spec_helper'

RSpec.describe Services::SaveSaltedgeTransaction do
  let(:user) { create(:user, :with_mirror_account, saltedge_id: "12345") }
  let(:saltedge_account) { user.default_mirror_account.saltedge_account }
  let(:transaction_data) {
    file = JSON.parse(File.read('spec/support/fixtures/saltedge_transactions_list_response.json'))
    file["data"][1]
  }
  let(:subject) { Services::SaveSaltedgeTransaction.new(saltedge_account.id, transaction_data)}

  it "stores saltedge transaction on saltedge account" do
    expect { subject.call }.to change { saltedge_account.saltedge_transactions.count }.by(1)
  end

  it "creates a mirror transaction on mirror account" do
    expect { subject.call }.to change { saltedge_account.virtual_account.transactions.mirror.count }.by(1)
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
    expect { subject.call }.to change {
      saltedge_account.virtual_account.transactions.automatic.count + dest_virtual_account.transactions.automatic.count
    }.by(2)
  end

  it "sets saltedge_id on mirror transaction" do
    subject.call
    expect(saltedge_account.virtual_account.transactions.mirror.where(saltedge_id: transaction_data["id"])).to_not be nil
  end
end
