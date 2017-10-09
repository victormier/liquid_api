require 'spec_helper'

RSpec.describe PercentageRule do
  let(:user) { create(:user, :with_mirror_account) }
  let(:virtual_account) { create(:virtual_account, :with_transactions, user: user) }
  let(:mirror_account) { user.default_mirror_account }
  let(:subject) { build(:percentage_rule, user: user, destination_virtual_account: virtual_account ) }
  let(:rule) {
    subject.save
    subject
  }

  before do
    mirror_account
  end

  it "allows creation of rule" do
    expect(subject.save).to be(true)
  end

  describe "#rule_applies" do
    it "returns true when applicable" do
      transaction =create(:mirror_transaction, amount: 100)
      expect(rule.rule_applies?(transaction)).to be true
    end

    it "returns false when not applicable" do
      transaction =create(:mirror_transaction, amount: 10)
      expect(rule.rule_applies?(transaction)).to be false
    end
  end

  describe "#apply_rule" do
    let(:transaction) { create(:mirror_transaction, virtual_account: mirror_account, amount: 100)}

    it "creates automatic transactions" do
      expect { rule.apply_rule(transaction) }.to change{ virtual_account.transactions.count }.by(1)
    end
  end
end
