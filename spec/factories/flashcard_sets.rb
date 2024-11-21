FactoryBot.define do
  factory :flashcard_set do
    name { "Set 1" }
    user { association :user } # or specify your user setup if necessary
    collection { association :collection } # Make sure to associate with a collection
  end
end
