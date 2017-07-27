require 'spec_helper'

RSpec.describe PasswordForm do
  let(:user) { User.create(email: "johndoe@example.com") }
  let(:params) { { password: "password", password_confirmation: "password" } }
  subject { PasswordForm.new(user)  }

  it "saves a user password properly" do
    expect(subject.validate(params)).to be true
    expect(subject.save).to be true
    expect(user.authenticate("password")).to eq user
  end

  context "validations" do
    it "validates presence of password" do
      subject.validate(params.merge({ password: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password]).to include("must be filled")
    end

    it "validates presence of password confirmation" do
      subject.validate(params.merge({ password_confirmation: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password_confirmation]).to include("must be filled")
    end

    it "validates equality of password confirmation to password" do
      subject.validate(params.merge({ password_confirmation: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password_confirmation]).to include("doesn't match password")
    end

    it "validates length of password" do
      password = "x" * 100
      subject.validate({password: password, password_confirmation: password})

      expect(subject.valid?).to be false
      expect(subject.errors[:password]).to include("size cannot be greater than 72")
    end
  end
end
