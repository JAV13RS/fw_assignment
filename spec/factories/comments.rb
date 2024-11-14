FactoryBot.define do
    factory :comment do
      comment { "this is a comment about the set" }
      flashcard_set
    end
  end