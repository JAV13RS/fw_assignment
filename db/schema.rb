# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_11_012815) do
  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "collections_flashcard_sets", id: false, force: :cascade do |t|
    t.integer "flashcard_set_id", null: false
    t.integer "collection_id", null: false
    t.index ["collection_id"], name: "index_collections_flashcard_sets_on_collection_id"
    t.index ["flashcard_set_id"], name: "index_collections_flashcard_sets_on_flashcard_set_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "flashcard_set_id", null: false
    t.integer "user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_set_id"], name: "index_comments_on_flashcard_set_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_favorites_on_collection_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "flashcard_sets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "collection_id"
    t.index ["collection_id"], name: "index_flashcard_sets_on_collection_id"
    t.index ["user_id"], name: "index_flashcard_sets_on_user_id"
  end

  create_table "flashcards", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.integer "flashcard_set_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_set_id"], name: "index_flashcards_on_flashcard_set_id"
  end

  create_table "hidden_flashcards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "flashcard_id", null: false
    t.boolean "hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_id"], name: "index_hidden_flashcards_on_flashcard_id"
    t.index ["user_id"], name: "index_hidden_flashcards_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "daily_set_limit", default: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collections", "users"
  add_foreign_key "comments", "flashcard_sets"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "collections"
  add_foreign_key "favorites", "users"
  add_foreign_key "flashcard_sets", "collections"
  add_foreign_key "flashcards", "flashcard_sets"
  add_foreign_key "hidden_flashcards", "flashcards"
  add_foreign_key "hidden_flashcards", "users"
end
