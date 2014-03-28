FactoryGirl.define do
  factory :user do
    last_login { 1.week.ago }
  end

  factory :facebook do
    provider 'facebook'
    oauth_token 'EAAE9hbnhqZAkBAPpgCrMf19PpL9ZAr0f209uMJ15NJJ88COEdZnxi5l63ZAsmSqOZADCK1mwpw8hEZBzIznE8VI8JvmV1lGxxLDdGZCZCRXdHYMVkHWN6oYgvXgE6W2ylxmqpLTYfpKZAziTNKQK1UV0GyqPWpwiFKPjNTfV5opkAsvFvE440oFlT'
    oauth_expires_at { 1.week.from_now }
    uid 2132362849
  end
end
