require 'rails_helper'

RSpec.describe Collection, type: :model do
  it "is valid with a user" do
    user = create(:user)
    collection = create(:collection, user: user)
    expect(collection).to be_valid
  end

  it "belongs to a user" do
    user = create(:user)
    collection = create(:collection, user: user)
    expect(collection.user).to eq(user)
  end

  it "can have multiple flashcard sets" do
    user = create(:user)
    collection = create(:collection, user: user)
    set1 = create(:flashcard_set)
    set2 = create(:flashcard_set)
    collection.flashcard_sets << [set1, set2]
    
    expect(collection.flashcard_sets.count).to eq(2)
  end
end
