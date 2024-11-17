class AddCollectionToFlashcardSets < ActiveRecord::Migration[8.0]
  def change
    add_reference :flashcard_sets, :collection, null: true, foreign_key: true
  end
end
