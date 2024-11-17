class AddUserIdToFlashcardSets < ActiveRecord::Migration[8.0]
  def change
    add_column :flashcard_sets, :user_id, :integer, null: true
    add_index :flashcard_sets, :user_id 
  end
end
