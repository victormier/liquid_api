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
end
