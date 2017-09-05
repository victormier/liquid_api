FactoryGirl.define do
  factory :saltedge_provider do
    saltedge_id "123"
    saltedge_data JSON.parse(File.read('spec/support/fixtures/saltedge_provider.json'))
    status "active"
    mode "web"
    name "Fake Bank"
    automatic_fetch true
    country_code "XF"
  end
end
