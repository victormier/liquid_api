require 'spec_helper'

RSpec.describe Services::ResetUserPassword do
  let(:user) {
    User.create(email: "johndoe@example.com",
                        password: "password")
  }
  subject { Services::ResetUserPassword.new(user)  }

  it "sets a new reset_password_token" do
    expect { subject.call }.to change{ user.reset_password_token }
  end

  it "sets a generated_at date for the token" do
    Timecop.freeze do
      subject.call
      expect(user.reload.reset_password_token_generated_at.to_i).to eq Time.now.to_i
    end
  end
end
