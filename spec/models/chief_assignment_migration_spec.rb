require "rails_helper"
require Rails.root.join("db/migrate/20261119121000_allow_chief_engineer_assignments")

RSpec.describe "Chief assignment migration" do
     let(:migration) { AllowChiefEngineerAssignments.new }

     it "refuses rollback while a chief is assigned, without changing their history" do
          task = tasks(:wing_test)
          task.assign_members([ users(:chief).id ], actor: users(:chief))
          expect { migration.suppress_messages { migration.down } }.to raise_error(ActiveRecord::IrreversibleMigration, /Unassign Chief Engineers/)
          expect(task.reload.assignees).to contain_exactly(users(:chief))
          ApplicationRecord.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
     end

     it "can roll back without chief assignments and reapply without losing existing work" do
          existing = TaskAssignment.order(:id).map(&:attributes)
          migration.suppress_messages { migration.down }
          expect do
               ApplicationRecord.transaction(requires_new: true) do
                    TaskAssignment.create!(task: tasks(:wing_test), user: users(:chief), assigned_by: users(:chief), assigned_at: Time.current)
                    ApplicationRecord.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
               end
          end.to raise_error(ActiveRecord::StatementInvalid)
          migration.suppress_messages { migration.up }
          TaskAssignment.create!(task: tasks(:wing_test), user: users(:chief), assigned_by: users(:chief), assigned_at: Time.current)
          ApplicationRecord.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
          expect(TaskAssignment.where(id: existing.map { |row| row["id"] }).order(:id).map(&:attributes)).to eq(existing)
     end
end
