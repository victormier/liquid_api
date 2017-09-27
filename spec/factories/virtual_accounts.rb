FactoryGirl.define do
  factory :virtual_account, aliases: [:related_virtual_account] do
    user
    balance 100.0
    currency_code "USD"

    after(:build) do |virtual_account|
      virtual_account.saltedge_account ||= FactoryGirl.build(:saltedge_account, virtual_account: virtual_account)
    end
  end
end
