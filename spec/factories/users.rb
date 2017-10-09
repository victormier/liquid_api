FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "password"
    confirmed_at Time.now.utc

    trait :with_mirror_account do
      after(:build) do |user|
        user.virtual_accounts << build(:virtual_account, :is_mirror_account, user: user)
      end
    end
  end
end
