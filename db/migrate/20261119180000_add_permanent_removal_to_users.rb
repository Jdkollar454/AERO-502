class AddPermanentRemovalToUsers < ActiveRecord::Migration[8.1]
     def up
          add_column :users, :permanently_removed_at, :datetime
          add_index :users, :permanently_removed_at
          add_check_constraint :users,
               "permanently_removed_at IS NULL OR (removed_at IS NOT NULL AND access_revoked_at IS NOT NULL AND password_digest IS NULL)",
               name: "permanently_removed_users_cannot_sign_in"
     end

     def down
          if select_value("SELECT EXISTS (SELECT 1 FROM users WHERE permanently_removed_at IS NOT NULL)")
               raise ActiveRecord::IrreversibleMigration, "Permanent removals exist; rolling back would expose accounts that cannot be restored."
          end

          remove_check_constraint :users, name: "permanently_removed_users_cannot_sign_in"
          remove_index :users, :permanently_removed_at
          remove_column :users, :permanently_removed_at
     end
end
