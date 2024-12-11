class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.integer :daily_set_limit, default: 20, null: false

      t.timestamps
    end
  end
end
