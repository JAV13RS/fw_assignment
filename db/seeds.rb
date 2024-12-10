require 'faker'

# Clear existing data
User.destroy_all
Collection.destroy_all
FlashcardSet.destroy_all
Flashcard.destroy_all
Comment.destroy_all

# Constants
NUM_USERS = 20
NUM_COLLECTIONS = 50
NUM_FLASHCARD_SETS = 100
NUM_FLASHCARDS = 500
NUM_COMMENTS = 300

# Seed users
users = []
admin = User.create!(email: 'admin@example.com', password: 'password', admin: true)
users << admin

19.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    admin: false
  )
end
puts "Created #{users.count} users."

# Seed collections
collections = []
NUM_COLLECTIONS.times do
  collections << Collection.create!(
    name: Faker::Book.genre,
    user: users.sample,
    public: [true, false].sample # Randomly assign public or private
  )
end
puts "Created #{collections.count} collections."

# Seed flashcard sets
flashcard_sets = []
NUM_FLASHCARD_SETS.times do
  flashcard_sets << FlashcardSet.create!(
    name: Faker::Educator.subject,
    user: users.sample,
    collection: collections.sample
  )
end
puts "Created #{flashcard_sets.count} flashcard sets."

# Seed flashcards
flashcards = []
NUM_FLASHCARDS.times do
  flashcards << Flashcard.create!(
    question: Faker::Lorem.question(word_count: 6),
    answer: Faker::Lorem.sentence(word_count: 10),
    flashcard_set: flashcard_sets.sample
  )
end
puts "Created #{flashcards.count} flashcards."

# Seed comments
comments = []
NUM_COMMENTS.times do
  comments << Comment.create!(
    comment: Faker::Lorem.sentence(word_count: 10),
    user: users.sample,
    flashcard_set: flashcard_sets.sample
  )
end
puts "Created #{comments.count} comments."

puts "Seeding complete!"
