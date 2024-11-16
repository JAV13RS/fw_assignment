class ChangeAdminInUsers < ActiveRecord::Migration[8.0]
  def up
    # Set default value for existing NULL rows
    User.where(admin: nil).update_all(admin: false)

    # Change column to have NOT NULL constraint and default value
    change_column :users, :admin, :boolean, default: false, null: false
  end

  def down
    # Revert the column change
    change_column :users, :admin, :boolean, default: nil, null: true
  end
end
