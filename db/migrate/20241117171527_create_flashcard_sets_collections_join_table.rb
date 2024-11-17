class CreateFlashcardSetsCollectionsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :flashcard_sets, :collections do |t|
      t.index :flashcard_set_id
      t.index :collection_id
    end
  end
end
