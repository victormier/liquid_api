FactoryGirl.define do
  factory :transaction do
    virtual_account
    amount 10.0
  end

  factory :mirror_transaction, parent: :transaction, class: MirrorTransaction do
    after(:build) do |mirror_transaction|
      mirror_transaction.saltedge_transaction ||= FactoryGirl.build(
        :saltedge_transaction,
        mirror_transaction: mirror_transaction,
        saltedge_account: mirror_transaction.virtual_account.try(:saltedge_account),
        amount: mirror_transaction.amount
      )
    end
  end

  factory :virtual_transaction, parent: :transaction, class: VirtualTransaction do
    related_virtual_account
  end
end
