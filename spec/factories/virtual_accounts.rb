FactoryGirl.define do
  factory :virtual_account do
    user

    after(:build) do |virtual_account|
      virtual_account.saltedge_account ||= FactoryGirl.build(:saltedge_account, virtual_account: virtual_account)
    end
  end
end
