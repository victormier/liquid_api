FactoryGirl.define do
  factory :percentage_rule do
    user
    destination_virtual_account
    active true
    config {{
      minimum_amount: 50.0,
      percentage: 21
    }}
  end
end
