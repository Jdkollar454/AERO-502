require "rails_helper"
require Rails.root.join("db/migrate/20261119180000_add_permanent_removal_to_users")
require Rails.root.join("db/migrate/20261124030000_merge_removal_into_access_revoked")

RSpec.describe "Permanent removal integrity" do
     let(:person) { users(:member) }

     def remove_permanently
          person.update!(access_revoked_at: Time.current)
          expect(person.permanently_remove(confirmation_name: person.name)).to be(true)
     end

     it "rejects stale restoration and repeated removal without changing the saved account" do
          stale_account = User.find(person.id)
          remove_permanently
          saved = person.attributes
          expect(stale_account.restore_access).to be(false)
          expect(stale_account.errors[:base]).to include("This person was permanently removed and cannot be changed or restored.")
          expect(person.reload.attributes).to eq(saved)
          expect(person.permanently_remove(confirmation_name: person.name)).to be(false)
          expect(person.errors[:base]).to include("This person was permanently removed and cannot be restored.")
          expect(person.reload.attributes).to eq(saved)
          expect(person).to be_valid
     end

     it "rechecks Removed status when a person was restored while the confirmation was open" do
          person.update!(access_revoked_at: Time.current)
          stale_account = User.find(person.id)
          person.restore_access
          expect(stale_account.permanently_remove(confirmation_name: person.name)).to be(false)
          expect(stale_account.errors[:base]).to include("Move this person to Removed people before permanently removing them.")
          expect(person.reload).not_to be_permanently_removed
          expect(person).not_to be_access_revoked
     end

     it "blocks reactivation even through direct database updates" do
          remove_permanently
          [ { access_revoked_at: nil }, { password_digest: "new-credential" } ].each do |attributes|
               expect do
                    User.transaction(requires_new: true) { User.where(id: person.id).update_all(attributes) }
               end.to raise_error(ActiveRecord::StatementInvalid, /permanently_removed_users_cannot_sign_in/)
          end
          expect(person.update(permanently_removed_at: nil)).to be(false)
          expect(person.reload).to be_permanently_removed
     end

     it "requires the person to be removed first, then erases their credentials" do
          expect(person.permanently_remove(confirmation_name: person.name)).to be(false)
          expect(person.errors[:base]).to include("Move this person to Removed people before permanently removing them.")
          person.update!(access_revoked_at: Time.current)
          expect(person.permanently_remove(confirmation_name: person.name)).to be(true)
          expect(person.reload.access_revoked_at).to be_present
          expect(person.password_digest).to be_nil
          expect(User.new(permanently_removed_at: Time.current)).to be_access_revoked
     end

     it "refuses migration rollback once a permanent removal exists" do
          remove_permanently
          migration = AddPermanentRemovalToUsers.new
          expect { migration.suppress_messages { migration.down } }.to raise_error(ActiveRecord::IrreversibleMigration, /Permanent removals exist/)
          expect(person.reload).to be_permanently_removed
     end

     it "can roll back and reapply the merge of removal into access_revoked_at without losing work or removals" do
          person.update!(access_revoked_at: Time.current)
          saved_work = TimeEntry.order(:id).map(&:attributes)
          User.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
          migration = MergeRemovalIntoAccessRevoked.new
          migration.suppress_messages { migration.down }
          expect(User.connection.select_value("SELECT removed_at IS NOT NULL FROM users WHERE id = #{person.id}")).to be(true)
          migration.suppress_messages { migration.up }
          User.reset_column_information
          expect(User.column_names).not_to include("removed_at")
          expect(TimeEntry.order(:id).map(&:attributes)).to eq(saved_work)
          expect(person.reload).to be_removed
          expect(User.allowed_to_sign_in).not_to include(person)
     end
end
