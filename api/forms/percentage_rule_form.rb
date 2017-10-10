require 'api/forms/rule_form'

class PercentageRuleForm < RuleForm
  property :minimum_amount
  property :percentage
  property :active

  validation do
    required(:minimum_amount).filled(:decimal?, gteq?: 0)
    required(:percentage).filled(:decimal?, gteq?: 0, lteq?: 100)
    optional(:active).filled(:bool?, :true?)
  end
end
