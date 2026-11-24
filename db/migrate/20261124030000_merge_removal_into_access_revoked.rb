# Removing a person and removing their access were recorded in two columns that meant the same
# thing for sign-in. The approved design has one, access_revoked_at; removed_at is folded into it.
class MergeRemovalIntoAccessRevoked < ActiveRecord::Migration[8.1]
     def up
          execute "UPDATE users SET access_revoked_at = removed_at WHERE removed_at IS NOT NULL AND access_revoked_at IS NULL"
          remove_check_constraint :users, name: "permanently_removed_users_cannot_sign_in"
          remove_index :users, :removed_at
          remove_column :users, :removed_at
          add_check_constraint :users,
               "permanently_removed_at IS NULL OR (access_revoked_at IS NOT NULL AND password_digest IS NULL)",
               name: "permanently_removed_users_cannot_sign_in"
     end

     def down
          remove_check_constraint :users, name: "permanently_removed_users_cannot_sign_in"
          add_column :users, :removed_at, :datetime
          add_index :users, :removed_at
          execute "UPDATE users SET removed_at = access_revoked_at WHERE access_revoked_at IS NOT NULL"
          add_check_constraint :users,
               "permanently_removed_at IS NULL OR (removed_at IS NOT NULL AND access_revoked_at IS NOT NULL AND password_digest IS NULL)",
               name: "permanently_removed_users_cannot_sign_in"
     end
end
