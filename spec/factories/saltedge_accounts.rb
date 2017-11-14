FactoryGirl.define do
  factory :saltedge_account do
    user
    sequence(:saltedge_id) { |n| n }
    saltedge_data JSON.parse(File.read('spec/support/fixtures/saltedge_account.json'))
    selected false

    after(:build) do |saltedge_account|
      unless saltedge_account.saltedge_login
        saltedge_account.saltedge_login = FactoryGirl.build(:saltedge_login, user: saltedge_account.user)
      end
    end

    trait(:with_virtual_account) do
      selected true
      after(:build) do |saltedge_account|
        saltedge_account.virtual_account ||= FactoryGirl.build(:virtual_account, saltedge_account: saltedge_account, user: saltedge_account.user)
      end
    end
  end
end
