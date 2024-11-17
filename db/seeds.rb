# First, clear any previous data to avoid duplication errors (if any)
User.destroy_all
Collection.destroy_all
FlashcardSet.destroy_all

# Create users first, making sure they are valid before creating collections
user1 = User.create!(email: "user1@example.com", password: "password123", password_confirmation: "password123", admin: false)
user2 = User.create!(email: "user2@example.com", password: "password123", password_confirmation: "password123", admin: false)

# Create flashcard sets
set1 = FlashcardSet.create!(name: "Math Set 1", user: user1)
set2 = FlashcardSet.create!(name: "Math Set 2", user: user1)
set3 = FlashcardSet.create!(name: "Science Set 1", user: user2)
set4 = FlashcardSet.create!(name: "History Set 1", user: user2)

# Now create collections, ensuring each collection has a valid user
collection1 = Collection.create!(user: user1, name: "Math studies")
collection1.flashcard_sets << [set1, set2]

collection2 = Collection.create!(user: user1, name: "Science sets ")
collection2.flashcard_sets << [set3]

collection3 = Collection.create!(user: user2, name: "History sets ")
collection3.flashcard_sets << [set4]

collection4 = Collection.create!(user: user2, name: "Mixed sets for general practice")
collection4.flashcard_sets << [set1, set3]

puts "Seed data created!"
