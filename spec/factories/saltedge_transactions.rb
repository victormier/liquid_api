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
        amount: mirror_transaction.amount
      )
    end
  end
end
