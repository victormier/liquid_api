require 'spec_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(first_name: "John",
                        last_name: "Doe",
                        email: "johndoe@example.com",
                        password: "password")
  }

  it "allows creation of a user" do
    expect(subject.save).to be true
  end
end
