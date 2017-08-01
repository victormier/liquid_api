require 'spec_helper'

RSpec.describe Services::SetUserPassword do
  let(:user) {
    User.create(email: "johndoe@example.com",
                        password: "password")
  }
  before { user.mark_as_confirmed! }

  let(:params) {
    { password: "newpassword",
      password_confirmation: "newpassword" }
  }
  subject { Services::SetUserPassword.new(user, params)  }

  it "updates a user password" do
    expect{ subject.call }.to change{ user.password_digest }
    expect(user.authenticate("newpassword")).to eq user
  end

  it "resets password token after succesfully changing the password" do
    subject.call
    expect(user.reset_password_token).to be nil
    expect(user.reset_password_token_generated_at).to be nil
  end

  it "returns false if saving the form fails" do
    allow_any_instance_of(PasswordForm).to receive(:save).and_return(false)
    expect(subject.call).to be false
  end

  it "returns false if the user email is not confirmed" do
    allow_any_instance_of(User).to receive(:confirmed?).and_return(false)
    expect(subject.call).to be false
    expect(subject.errors).to include "Email is not confirmed"
  end
end
