require 'spec_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(first_name: "John",
                        last_name: "Doe",
                        email: "johndoe@example.com",
                        password: "password")
  }
  let(:user) {
    expect(subject.save).to be true
    subject
  }

  it "allows creation of a user" do
    expect(subject.save).to be true
  end

  describe "#reset_password_token" do
    it "is invalid after 1 day" do
      user.reset_password_token_generated_at = Time.now.utc
      expect(user.reset_password_token_valid?).to be true
      Timecop.freeze(Time.now + 60*60*25) # > 1 day from now
      expect(user.reset_password_token_valid?).to be false
    end
  end

  it "destroys associated data when destroyed" do
    saltedge_login = create(:saltedge_login, user: user)
    saltedge_account = create(:saltedge_account, :with_virtual_account, user: user, saltedge_login: saltedge_login)
    user.destroy
    expect{ saltedge_login.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    expect{ saltedge_account.reload }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
