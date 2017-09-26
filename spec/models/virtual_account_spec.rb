require 'spec_helper'

RSpec.describe VirtualAccount, type: :model do
  subject {
    build(:virtual_account)
  }
  let(:virtual_account) {
    expect(subject.save).to be true
    subject
  }

  it "allows creation of a user" do
    expect(subject.save).to be true
  end

  it "destroys associated data when destroyed" do
    transactions = create_list(:mirror_transaction, 5, virtual_account: virtual_account)
    virtual_account_id = virtual_account.id
    virtual_account.destroy

    expect(Transaction.where(virtual_account_id: virtual_account_id)).to be_empty
  end
end
