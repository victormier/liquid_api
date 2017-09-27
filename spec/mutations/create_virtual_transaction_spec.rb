require 'spec_helper'

RSpec.describe Mutations::CreateVirtualTransaction do
  let(:user) { create(:user) }
  let(:origin_account) { create(:virtual_account, user: user) }
  let(:destination_account) { create(:virtual_account, user: user) }
  let(:subject) { Schema.types["Mutation"].fields["createVirtualTransaction"] }
  let(:args) {
    {
      "origin_account_id": origin_account.id,
      "destination_account_id": destination_account.id,
      "amount": 10.0
    }
  }

  it "creates a new virtual transaction with valid data" do
    expect { subject.resolve(nil, args, { current_user: user }) }.to change{ user.virtual_accounts.reload.map { |va| va.transactions.reload.count }.sum }.by(2)
  end

  it "raises an exception if validation fails" do
    origin_account.update_attributes(currency_code: "EUR")
    expect { subject.resolve(nil, args, { current_user: user }) }.to raise_exception(GraphQL::ExecutionError)
  end
end
