# Clear all data in the correct order to avoid foreign key constraint violations
Comment.destroy_all    # Destroy comments first because they depend on flashcard sets
FlashcardSet.destroy_all # Destroy flashcard sets first because collections depend on them
Collection.destroy_all # Destroy collections next because they depend on flashcard sets
User.destroy_all       # Destroy users last because flashcard sets and collections depend on users

# Recreate users first
user1 = User.create!(email: "user1@example.com", password: "password123", password_confirmation: "password123", admin: false)
user2 = User.create!(email: "user2@example.com", password: "password123", password_confirmation: "password123", admin: false)

# Create flashcard sets and associate them with users
set1 = FlashcardSet.create!(name: "Math Set 1", user: user1)
set2 = FlashcardSet.create!(name: "Math Set 2", user: user1)
set3 = FlashcardSet.create!(name: "Science Set 1", user: user2)
set4 = FlashcardSet.create!(name: "History Set 1", user: user2)

# Add comments to flashcard sets, ensuring the flashcard sets and users exist
Comment.create!(comment: "Great for basic arithmetic!", user: user1, flashcard_set: set1)
Comment.create!(comment: "Perfect for advanced algebra practice.", user: user1, flashcard_set: set2)
Comment.create!(comment: "Detailed overview of physics principles.", user: user2, flashcard_set: set3)
Comment.create!(comment: "Covers major historical events.", user: user2, flashcard_set: set4)

# Now create collections
collection1 = Collection.create!(user: user1, name: "Math studies")
collection1.flashcard_sets << set1 << set2

collection2 = Collection.create!(user: user1, name: "Science sets")
collection2.flashcard_sets << set3

collection3 = Collection.create!(user: user2, name: "History sets")
collection3.flashcard_sets << set4

collection4 = Collection.create!(user: user2, name: "Mixed sets for general practice")
collection4.flashcard_sets << set1 << set3

puts "Seed data created successfully!"
