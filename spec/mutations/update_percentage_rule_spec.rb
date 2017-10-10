require 'spec_helper'

RSpec.describe Mutations::UpdatePercentageRule do
  let(:user) { create(:user, :with_mirror_account) }
  let(:percentage_rule) { create(:percentage_rule, user: user, config: { percentage: 21.0, minimum_amount: 50 }) }
  let(:subject) { Schema.types["Mutation"].fields["updatePercentageRule"] }
  let(:args) {{ minimum_amount: 100.0, percentage: 21, percentage_rule_id: percentage_rule.id }}

  it "updates percentage rule with valid data" do
    subject.resolve(nil, args, { current_user: user })
    expect(percentage_rule.reload.minimum_amount).to eq(100.0)
  end

  it "raises an exception if validation fails" do
    expect { subject.resolve(nil, args.merge({ minimum_amount: -50.0 }), { current_user: user }) }.to raise_exception(GraphQL::ExecutionError)
  end
end
