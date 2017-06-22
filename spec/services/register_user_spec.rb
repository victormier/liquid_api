require 'spec_helper'

RSpec.describe RegisterUser do
  let(:user) {
    User.create(email: "johndoe@example.com",
                        password: "password")
  }
  let(:params) {
    { first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
      password: "password" }
  }
  subject { RegisterUser.new(params)  }

  it "creates a new user with valid params" do
    expect{ subject.call }.to change{ User.count }.by(1)
  end

  it "generates an email confirmation token for the user" do
    subject.call
    expect(subject.model.confirmation_token).to_not be nil
  end

  it "submits an email confirmation email" do
    expect{ subject.call }.to change{ Mail::TestMailer.deliveries.length }.by(1)
    expect(Mail::TestMailer.deliveries.last.subject).to eq "Liquid email confirmation"
    expect(Mail::TestMailer.deliveries.last.to).to include params[:email]
  end

  it "returns false if params not valid" do
    params[:email] = nil
    subject = RegisterUser.new(params)
    expect(subject.call).to be_falsey
    expect(subject.form.errors).to_not be_empty
  end

  it "raises an exception if saving the form fails" do
    allow_any_instance_of(UserForm).to receive(:save).and_return(false)
    expect{ subject.call }.to raise_exception("There was a problem saving the user")
  end

end
