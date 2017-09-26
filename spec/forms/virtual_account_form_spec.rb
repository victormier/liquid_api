require 'spec_helper'

RSpec.describe UserForm do
  let(:params) {
    {
      name: "My Cool Account",
      currency_code: "USD"
    }
  }
  let(:user) { create(:user) }

  subject { VirtualAccountForm.new(user.virtual_accounts.new)  }

  it "creates a new virtual account with valid data" do
    subject.validate(params)

    expect(subject.valid?).to be true
    expect(subject.save).to be true
    expect(subject.model.persisted?).to be true
  end

  context "validations" do
    it "validates format of currency_code" do
      subject.validate(params.merge({ currency_code: "bad_code" }))

      expect(subject.valid?).to be false
      expect(subject.errors[:currency_code]).to include("should be a valid ISO 4217 currency code")
    end

    it "validates presence of name" do
      subject.validate(params.merge({ name: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:name]).to include("must be filled")
    end

    it "validates uniqueness of name" do
      user.virtual_accounts.create(name: "My Cool Account", currency_code: "USD")
      subject.validate(params)

      expect(subject.valid?).to be false
      expect(subject.errors[:name]).to include("must be unique (not already taken)")
    end

    it "allows another user to create a virtual account with same name" do
      new_user = create(:user)
      subject.validate(params)
      expect(subject.save).to be true

      new_form = VirtualAccountForm.new(new_user.virtual_accounts.new)
      new_form.validate(params)
      expect(new_form.valid?).to be true
      expect(new_form.save).to be true
    end
  end
end
