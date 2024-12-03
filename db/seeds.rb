# Clear all data in the correct order to avoid foreign key constraint violations
Comment.destroy_all    # Destroy comments first because they depend on flashcard sets
FlashcardSet.destroy_all # Destroy flashcard sets first because collections depend on them
Collection.destroy_all # Destroy collections next because they depend on flashcard sets
User.destroy_all       # Destroy users last because flashcard sets and collections depend on users

# Recreate Users
user1 = User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password', admin: false)
user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password', admin: true)

# Create Flashcard Sets for User 1
set1 = FlashcardSet.create!(name: 'Math Set 1', user: user1)
set2 = FlashcardSet.create!(name: 'Math Set 2', user: user1)
set3 = FlashcardSet.create!(name: 'Science Set 1', user: user2)
set4 = FlashcardSet.create!(name: 'History Set 1', user: user2)

# Create Flashcards for Flashcard Sets of User 1 and User 2
10.times do |i|
  set1.flashcards.create!(question: "Math Question #{i+1}", answer: "Math Answer #{i+1}")
  set2.flashcards.create!(question: "Math Question #{i+1}", answer: "Math Answer #{i+1}")
end

10.times do |i|
  set3.flashcards.create!(question: "Science Question #{i+1}", answer: "Science Answer #{i+1}")
end

10.times do |i|
  set4.flashcards.create!(question: "History Question #{i+1}", answer: "History Answer #{i+1}")
end

# Create Collections for User 1
collection1_user1 = user1.collections.create!(name: 'Math studies')
collection2_user1 = user1.collections.create!(name: 'Science sets')

# Associate Flashcard Sets with Collections of User 1
collection1_user1.flashcard_sets << set1 << set2
collection2_user1.flashcard_sets << set3

# Create Collections for User 2
collection1_user2 = user2.collections.create!(name: 'History sets')
collection2_user2 = user2.collections.create!(name: 'Mixed sets for general practice')

# Associate Flashcard Sets with Collections of User 2
collection1_user2.flashcard_sets << set4
collection2_user2.flashcard_sets << set1 << set3

puts "Seed data created successfully!"
