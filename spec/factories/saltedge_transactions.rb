FactoryGirl.define do
  factory :saltedge_transaction do
    saltedge_account
    amount 10.0
    sequence(:saltedge_id) { |n| n }
    status "posted"
    currency_code "USD"

    after(:build) do |saltedge_transaction|
      saltedge_transaction.mirror_transaction ||= FactoryGirl.build(
        :mirror_transaction,
        saltedge_transaction: saltedge_transaction,
        amount: saltedge_transaction.amount,
        virtual_account: saltedge_transaction.saltedge_account.virtual_account || FactoryGirl.build(:virtual_account, user: saltedge_transaction.saltedge_account.user, saltedge_account: saltedge_transaction.saltedge_account)
      )
    end
  end
end
