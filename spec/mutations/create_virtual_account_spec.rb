require 'spec_helper'

RSpec.describe Mutations::CreateVirtualAccount do
  let(:user) { create(:user) }
  let(:saltedge_account) { create(:saltedge_account, user: user) }
  let(:subject) { Schema.types["Mutation"].fields["createVirtualAccount"] }
  let(:args) {{ "name": "My cool account" }}

  before { saltedge_account }

  it "creates a new virtual account with valid data" do
    expect { subject.resolve(nil, args, { current_user: user }) }.to change{ user.virtual_accounts.count }.by(1)
  end

  it "raises an exception if validation fails" do
    user.virtual_accounts.create(name: "My cool account", currency_code: "USD")
    expect { subject.resolve(nil, args, { current_user: user }) }.to raise_exception(GraphQL::ExecutionError)
  end
end
