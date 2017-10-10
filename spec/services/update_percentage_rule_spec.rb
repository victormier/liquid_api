require 'spec_helper'

RSpec.describe Services::UpdatePercentageRule do
  let(:user) { create(:user, :with_mirror_account) }
  let(:percentage_rule) { create(:percentage_rule, user: user, config: { percentage: 21.0, minimum_amount: 50 }) }
  subject { Services::UpdatePercentageRule.new(user, {
      percentage_rule_id: percentage_rule.id,
      minimum_amount: 100
    }
  )}

  it "updates a percentage rule" do
    subject.call
    expect(percentage_rule.reload.minimum_amount).to eq(100)
  end

  it "fails if validation fails" do
    params = {
      percentage_rule_id: percentage_rule.id,
      minimum_amount: -100
    }
    service = Services::UpdatePercentageRule.new(user, params)
    expect{ service.call }.to raise_exception(LiquidApi::MutationInvalid)
  end

  it "raises an exception if rule doesn't exist" do
    params = {
      percentage_rule_id: 99999,
      minimum_amount: 100
    }
    service = Services::UpdatePercentageRule.new(user, params)
    expect{ service.call }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
