require "rails_helper"

RSpec.describe "Chief Engineer self-assignment", type: :request do
     let(:chief) { users(:chief) }

     before { sign_in(chief) }

     it "offers the chief on new and existing task forms without requiring a membership" do
          [ new_task_path, edit_task_path(tasks(:wing_test)) ].each do |path|
               get path
               expect(response.parsed_body.at_css("#task_assignee_ids option[value='#{chief.id}']")["data-all-teams"]).to eq("true")
          end
          expect(chief.membership).to be_nil
     end

     it "saves self-assignment across teams, preserves other assignees and records hours in reports" do
          [ tasks(:wing_test), tasks(:spar_check) ].each do |task|
               previous = task.assignee_ids
               patch task_path(task), params: { task: { assignee_ids: previous + [ chief.id ], primary_contact_id: chief.id } }
               expect(response).to redirect_to(task_path(task))
               expect(task.reload.assignee_ids).to match_array(previous + [ chief.id ])
               expect(task.primary_contact).to eq(chief)
               ApplicationRecord.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
          end
          get tasks_path(view: "mine")
          expect(response.body).to include("Wing load test", "Verify spar dimensions")
          expect(response.parsed_body.at_css("#filter_member_id option[value='#{chief.id}']")).to be_present

          post task_time_entries_path(tasks(:wing_test)), params: { time_entry: { hours: "2", worked_on: Date.current, note: "Chief contribution" } }
          expect(chief.time_entries.sum(:hours)).to eq(2)
          get member_hours_report_path(format: :csv)
          expect(response.body).to include(chief.name, "2.0")
          get edit_task_path(tasks(:wing_test))
          expect(response.parsed_body.at_css("#task_assignee_ids option[value='#{chief.id}'][selected]")).to be_present
     end

     it "allows self-assignment when creating a task" do
          post tasks_path, params: { task: { title: "Chief design review", project_id: projects(:airframe_build).id,
               start_date: Date.current, due_date: Date.current + 3, estimated_hours: 2, assignee_ids: [ chief.id ] } }
          task = Task.find_by!(title: "Chief design review")
          expect(response).to redirect_to(task_path(task))
          expect(task.assignees).to contain_exactly(chief)
     end

     it "retains an assigned chief when an officer edits the task but rejects new chief and cross-team assignments" do
          task = tasks(:wing_test)
          task.assign_members([ chief.id ], actor: chief)
          sign_in(users(:officer))
          get edit_task_path(task)
          expect(response.parsed_body.at_css("#task_assignee_ids option[value='#{chief.id}'][selected]")).to be_present
          patch task_path(task), params: { task: { title: "Updated by officer", assignee_ids: [ chief.id ] } }
          expect(response).to redirect_to(task_path(task))
          patch task_path(task), params: { task: { assignee_ids: [ users(:other_member).id ] } }
          expect(response).to have_http_status(:unprocessable_content)
          task.assign_members([], actor: users(:officer))
          patch task_path(task), params: { task: { assignee_ids: [ chief.id ] } }
          expect(response).to have_http_status(:unprocessable_content)
     end

     it "requires resolving incompatible assignments before a chief becomes a team member" do
          users(:other_officer).update!(role: :chief_engineer, subteam: nil)
          tasks(:spar_check).assign_members([ chief.id ], actor: chief)
          patch user_path(chief), params: { user: { role: "member", subteam_id: subteams(:wing).id } }
          expect(response).to have_http_status(:unprocessable_content)
          expect(chief.reload).to be_chief_engineer
          expect(chief.assigned_tasks).to include(tasks(:spar_check))
     end
end
