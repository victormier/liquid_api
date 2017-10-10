FactoryGirl.define do
  factory :virtual_account, aliases: [:related_virtual_account, :destination_virtual_account] do
    user
    balance 100.0
    currency_code "USD"

    after(:build) do |virtual_account|
      virtual_account.saltedge_account ||= FactoryGirl.build(:saltedge_account, virtual_account: virtual_account)
    end

    trait :with_transactions do
      after(:build) do |virtual_account|
        virtual_account.transactions << build_list(:virtual_transaction, 5, virtual_account: virtual_account)
      end
    end

    trait :is_mirror_account do
      after(:build) do |virtual_account|
        virtual_account.saltedge_account = build(:saltedge_account, user: virtual_account.user)
      end
    end
  end
end
