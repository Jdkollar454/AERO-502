require "rails_helper"

RSpec.describe "People directory", type: :request do
     before { sign_in(users(:chief)) }

     it "searches names and emails without case sensitivity and treats wildcard characters literally" do
          get users_path, params: { q: "  mOrGaN  " }
          expect(response.parsed_body.css("tbody th").map(&:text)).to eq([ users(:member).name ])
          get users_path, params: { q: "OTHER.MEMBER@" }
          expect(response.parsed_body.css("tbody th").map(&:text)).to eq([ users(:other_member).name ])
          get users_path, params: { q: "%" }
          expect(response.body).to include("No people found")
     end

     it "paginates a semester roster and keeps the search on subsequent pages" do
          80.times do |index|
               User.create!(name: format("Semester Member %02d", index), email: "semester#{index}@tamu.edu", subteam: subteams(:wing))
          end
          get users_path, params: { q: "Semester", page: 2 }
          expect(response.parsed_body.css("tbody tr").count).to eq(25)
          expect(response.body).to include("Semester Member 25", "Semester Member 49", "80 people")
          expect(response.parsed_body.at_css("a[rel='next']")["href"]).to include("page=3", "q=Semester")
          get users_path, params: { q: "Semester", page: 999 }
          expect(response.parsed_body.css("tbody tr").count).to eq(5)
          expect(response.body).to include("Page 4 of 4")
     end

     it "confirms removal, hides the person, preserves work and restores the same account" do
          member = users(:member)
          before_work = [ member.task_assignments.map(&:attributes), member.time_entries.map(&:attributes), TaskStatusChange.count ]
          get removal_user_path(member)
          expect(response.body).to include("Remove Morgan Member?", "Their task assignments, logged hours and task history will stay.")
          expect { delete user_path(member) }.not_to change(User, :count)
          expect(member.reload).to be_removed
          expect(member).to be_access_revoked
          expect([ member.task_assignments.reload.map(&:attributes), member.time_entries.reload.map(&:attributes), TaskStatusChange.count ]).to eq(before_work)
          get users_path, params: { q: member.name }
          expect(response.parsed_body.css("tbody tr")).to be_empty
          get users_path, params: { view: "removed", q: member.name }
          expect(response.parsed_body.css("tbody th").map(&:text)).to eq([ member.name ])
          get task_path(tasks(:wing_test))
          expect(response.body).to include(member.name, "2.5 hours")
          get member_hours_report_path(format: :csv)
          expect(response.body).to include(member.name, "2.5")
          expect(User.task_candidates(teams(:aerodynamics).id, actor: users(:chief))).not_to include(member)
          patch restore_user_path(member)
          expect(member.reload).not_to be_removed
          expect(member).not_to be_access_revoked
          expect(member.time_entries.count).to eq(1)
          sign_in(member)
          expect(response).to redirect_to(root_path)
     end

     it "blocks a removed person's existing session and password sign-in" do
          member = users(:member)
          client = ActionDispatch::Integration::Session.new(Rails.application)
          client.post login_path, params: { email: member.email, password: "password" }
          delete user_path(member)
          client.patch task_path(tasks(:wing_test)), params: { task: { status: "completed" } }
          expect(client.response.status).to eq(302)
          expect(client.response.location).to eq("http://www.example.com#{login_path}")
          expect(tasks(:wing_test).reload).to be_backlog
          client.post login_path, params: { email: member.email, password: "password" }
          expect(client.response).to have_http_status(:unprocessable_content)
     end

     it "moves a person whose access is removed to Removed people and protects the final active chief from removal" do
          patch revoke_user_path(users(:member))
          get users_path, params: { q: users(:member).name }
          expect(response.parsed_body.css("tbody th").map(&:text)).to eq([])
          get users_path, params: { q: users(:member).name, view: "removed" }
          expect(response.parsed_body.css("tbody th").map(&:text)).to eq([ users(:member).name ])
          delete user_path(users(:chief))
          expect(flash[:alert]).to include("At least one active Chief Engineer is required")
          expect(users(:chief).reload).not_to be_removed
          expect(users(:chief)).not_to be_access_revoked
     end

     it "explains a failed restoration and keeps access blocked when an old account is incomplete" do
          member = users(:member)
          delete user_path(member)
          # Simulate an incomplete account left by an older import.
          member.update_columns(name: "")
          patch restore_user_path(member)
          expect(response).to redirect_to(users_path)
          expect(flash[:alert]).to include("Name can't be blank")
          expect(member.reload).to be_removed
          expect(member).to be_access_revoked
     end

     it "allows removing a chief only when another active chief remains" do
          successor = users(:other_officer)
          successor.update!(role: :chief_engineer, subteam: nil)
          delete user_path(successor)
          expect(successor.reload).to be_removed
          delete user_path(users(:chief))
          expect(users(:chief).reload).not_to be_removed
     end

     it "denies directory search, removal and restoration to officers and members" do
          [ users(:officer), users(:member) ].each do |person|
               sign_in(person)
               get users_path, params: { q: "Casey", view: "removed" }
               expect(response).to redirect_to(root_path)
               get removal_user_path(users(:other_member))
               expect(response).to redirect_to(root_path)
               delete user_path(users(:other_member))
               expect(response).to redirect_to(root_path)
               expect(users(:other_member).reload).not_to be_removed
               patch restore_user_path(users(:other_member))
               expect(response).to redirect_to(root_path)
          end
     end
end
