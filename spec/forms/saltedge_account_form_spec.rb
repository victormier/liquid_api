require 'spec_helper'

RSpec.describe SaltedgeAccountForm do
  let(:user) {create(:user, saltedge_id: "12345") }
  let(:saltedge_login) {create(:saltedge_login, user: user) }
  let(:params) {
    {
      saltedge_login_id: saltedge_login.id,
      user_id: user.id,
      saltedge_id: "9999",
      saltedge_data: { "data": "test" },
      selected: false
    }
  }
  subject { SaltedgeAccountForm.new(user.saltedge_accounts.new)  }

  it "creates a new saltedge account with valid data" do
    subject.validate(params)

    expect(subject.valid?).to be true
    expect(subject.save).to be true
    expect(subject.model.persisted?).to be true
  end

  context "validations" do
    it "validates there's only one selected" do
      params[:selected] = true
      subject.validate(params)
      subject.save
      new_form = SaltedgeAccountForm.new(user.saltedge_accounts.new)
      subject.validate(params)
      expect(subject.valid?).to be false
      expect(subject.errors[:selected]).to include("must be unique when true")
    end
    # it "validates format of currency_code" do
    #   subject.validate(params.merge({ currency_code: "bad_code" }))
    #
    #   expect(subject.valid?).to be false
    #   expect(subject.errors[:currency_code]).to include("should be a valid ISO 4217 currency code")
    # end
  end
end
