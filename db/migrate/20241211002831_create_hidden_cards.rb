class CreateHiddenCards < ActiveRecord::Migration[8.0]
  def change
    create_table :hidden_flashcards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flashcard, null: false, foreign_key: true
      t.boolean :hidden

      t.timestamps
    end
  end
end
