require 'spec_helper'

RSpec.describe Mutations::SelectSaltedgeAccount do
  let(:user) { create(:user) }
  let(:saltedge_account) { create(:saltedge_account, user: user, selected: false) }
  let(:subject) { Schema.types["Mutation"].fields["selectSaltedgeAccount"] }
  let(:args) {{ "saltedge_account_id": saltedge_account.id }}

  it "marks a saltedge account as selected with valid data" do
    expect {
      subject.resolve(nil, args, { current_user: user })
    }.to change{ user.virtual_accounts.mirror.count }.by(1)
    expect(saltedge_account.reload.selected).to be true
  end

  it "raises an exception if validation fails" do
    create(:saltedge_account, user: user, selected: true)
    expect { subject.resolve(nil, args, { current_user: user }) }.to raise_exception(GraphQL::ExecutionError)
  end
end
