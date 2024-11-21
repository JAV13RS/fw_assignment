FactoryBot.define do
  factory :collection do
    name { "Collection 1" }
    user { association :user } 
  end
end
