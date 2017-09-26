FactoryGirl.define do
  factory :saltedge_account do
    user
    saltedge_login
    sequence(:saltedge_id) { |n| n }
    saltedge_data JSON.parse(File.read('spec/support/fixtures/saltedge_account.json'))

    after(:build) do |saltedge_account|
      saltedge_account.virtual_account ||= FactoryGirl.build(:virtual_account, saltedge_account: saltedge_account)
    end
  end
end
