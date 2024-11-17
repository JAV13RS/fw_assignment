FactoryBot.define do
    factory :collection do
      association :user
      flashcard_sets { [] }  # Will be set in the test
    end
  end