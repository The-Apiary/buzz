FactoryGirl.define do
  factory :user do
    last_login { 1.week.ago }
  end
end
