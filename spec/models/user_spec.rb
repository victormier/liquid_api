require 'spec_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(first_name: "John",
                        last_name: "Doe",
                        email: "johndoe@example.com",
                        password: "password")
  }

  context "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to have_secure_password }
  end

  it "allows creation of a user" do
    expect(subject.save).to be true
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

end
