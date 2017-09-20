FactoryGirl.define do
  factory :saltedge_login do
    user
    saltedge_provider
    sequence(:saltedge_id) { |n| n }
    saltedge_data JSON.parse(File.read('spec/support/fixtures/saltedge_login.json'))
  end
end
