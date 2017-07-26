require 'spec_helper'

RSpec.describe UserForm do
  before {
    @params = { first_name: "John",
                last_name: "Doe",
                email: "johndoe@example.com",
                password: "password",
                password_confirmation: "password" }
  }
  subject { UserForm.new(User.new)  }

  it "creates a new user with valid data" do
    expect(subject.validate(@params)).to be true
    expect(subject.save).to be true
    expect(subject.model.persisted?).to be true
  end

  context "validations" do
    it "validates presence of email" do
      subject.validate(@params.merge({ email: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:email]).to include("must be filled")
    end

    it "validates format of email" do
      subject.validate(@params.merge({ email: "notanemail" }))

      expect(subject.valid?).to be false
      expect(subject.errors[:email]).to include("is in invalid format")
    end

    it "validates uniqueness of email" do
      user = User.create(email: @params[:email], password: "password")
      expect(user.persisted?).to be true
      subject.validate(@params)
      expect(subject.valid?).to be false
      expect(subject.errors[:email]).to include("is already taken")
    end

    it "validates case-insensitive uniqueness of email" do
      user = User.create(email: @params[:email], password: "password")
      expect(user.persisted?).to be true
      subject.validate(@params.merge({email: @params[:email].upcase}))

      expect(subject.valid?).to be false
      expect(subject.errors[:email]).to include("is already taken")
    end

    it "validates presence of password" do
      subject.validate(@params.merge({ password: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password]).to include("must be filled")
    end

    it "validates presence of password confirmation" do
      subject.validate(@params.merge({ password_confirmation: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password_confirmation]).to include("must be filled")
    end

    it "validates equality of password confirmation to password" do
      subject.validate(@params.merge({ password_confirmation: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:password_confirmation]).to include("doesn't match password")
    end
  end
end
