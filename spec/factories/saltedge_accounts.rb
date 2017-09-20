FactoryGirl.define do
  factory :saltedge_account do
    user
    saltedge_login
    sequence(:saltedge_id) { |n| n }
    saltedge_data JSON.parse(File.read('spec/support/fixtures/saltedge_account.json'))
  end
end
