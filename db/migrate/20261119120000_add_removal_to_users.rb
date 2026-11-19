class AddRemovalToUsers < ActiveRecord::Migration[8.1]
     def change
          add_column :users, :removed_at, :datetime
          add_index :users, :removed_at
     end
end
