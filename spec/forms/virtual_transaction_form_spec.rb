require 'spec_helper'

RSpec.describe UserForm do
  let(:origin_account) { create(:virtual_account, balance: 200.0) }
  let(:destination_account) { create(:virtual_account, user: origin_account.user) }
  let(:params) {
    {
      made_on: DateTime.now,
      amount: -10.0,
      virtual_account_id: origin_account.id,
      related_virtual_account_id: destination_account.id
    }
  }

  subject { VirtualTransactionForm.new(VirtualTransaction.new)  }

  it "creates a new virtual transaction with valid data" do
    subject.validate(params)

    expect(subject.valid?).to be true
    expect(subject.save).to be true
    expect(subject.model.persisted?).to be true
  end

  context "validations" do
    it "validates presence of made_on" do
      subject.validate(params.merge({ made_on: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:made_on]).to include("must be filled")
    end

    it "validates presence of virtual account" do
      subject.validate(params.merge({ virtual_account_id: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:virtual_account_id]).to include("must be filled")
    end

    it "validates presence of related virtual account" do
      subject.validate(params.merge({ related_virtual_account_id: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:related_virtual_account_id]).to include("must be filled")
    end

    it "validates presence of amount" do
      subject.validate(params.merge({ amount: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:amount]).to include("must be filled")
    end

    it "validates format of amount" do
      subject.validate(params.merge({ amount: "asdf" }))

      expect(subject.valid?).to be false
      expect(subject.errors[:amount]).to include("must be a decimal")
    end

    it "allows negative amount values" do
      subject.validate(params.merge({ amount: -5 }))

      expect(subject.valid?).to be true
    end

    it "fails if origin account has insufficient funds for negative transactions" do
      origin_account.update_attributes(balance: 5.0);
      subject.validate(params)

      expect(subject.valid?).to be false
    end

    it "validates both accounts have the same currency" do
      origin_account.update_attributes(currency_code: "EUR")
      subject.validate(params)

      expect(subject.valid?).to be false
      expect(subject.errors[:virtual_account_id]).to include("must have the same currency as the other account")
    end

    it "validates both accounts belong to the same user" do
      new_account = create(:virtual_account)
      subject.validate(params.merge({ related_virtual_account_id: new_account.id }))

      expect(subject.valid?).to be false
      expect(subject.errors[:virtual_account_id]).to include("must be owned by the same user as the other account")
    end

    it "validates virtual account exists" do
      params
      origin_account.destroy
      subject.validate(params)

      expect(subject.valid?).to be false
      expect(subject.errors[:virtual_account_id]).to include("must exist in database")
    end

    it "validates related virtual account exists" do
      params
      destination_account.destroy
      subject.validate(params)

      expect(subject.valid?).to be false
      expect(subject.errors[:related_virtual_account_id]).to include("must exist in database")
    end
  end
end
