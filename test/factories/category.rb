FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "category #{n}" }
    podcasts {[create(:podcast), create(:podcast)]}
  end
end


