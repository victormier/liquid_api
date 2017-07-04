require 'spec_helper'

RSpec.describe "RegisterUser Mutation" do
  let(:register_user_field) { Schema.types["Mutation"].fields["registerUser"] }
  let(:args) { { "user": { "email": "johndoe@example.com", "password": "password" } } }

  it "registers a user with valid data" do
    expect { register_user_field.resolve(nil, args, nil) }.to change{ User.count }.by(1)
  end

  it "raises an exception if registration fails" do
    invalid_args = { "user": { "email": "invalidemail", "password": "password" } }
    expect{ register_user_field.resolve(nil, invalid_args, nil) }.
      to raise_exception(GraphQL::ExecutionError, "Email is in invalid format")
  end

  it "fails if password not provided" do
    invalid_args = { "user": { "email": "johndoe@exmple.com"  } }
    expect{ register_user_field.resolve(nil, invalid_args, nil) }.
      to raise_exception(GraphQL::ExecutionError, "Password must be filled")
  end
end
