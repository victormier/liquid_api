class PercentageRuleForm < BaseForm
  property :minimum_amount
  property :percentage
  property :active
  property :config

  validation do
    required(:minimum_amount).filled(:decimal?, gteq?: 0)
    required(:percentage).filled(:decimal?, gteq?: 0)
    optional(:active).filled(:bool?, :true?)
  end
end
