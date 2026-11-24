require "rails_helper"

RSpec.describe "Permanent People removal", type: :request do
     before { sign_in(users(:chief)) }

     it "requires the Removed list and an exact name confirmation, including for direct requests" do
          person = users(:member)
          get users_path
          expect(response.body).not_to include("Permanently remove")
          get permanent_removal_user_path(person)
          expect(response).to redirect_to(users_path(view: "removed"))
          delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("Move this person to Removed people")
          expect(person.reload).not_to be_removed

          delete user_path(person)
          get users_path, params: { view: "removed" }
          expect(response.parsed_body.at_css("a[href='#{permanent_removal_user_path(person)}']").text).to eq("Permanently remove")
          get permanent_removal_user_path(person)
          expect(response.body).to include("This cannot be undone.", "Their name will remain", "email and sign-in credentials will be erased")
          [ nil, "Someone else" ].each do |confirmation|
               delete permanently_remove_user_path(person), params: { confirmation_name: confirmation }
               expect(response).to have_http_status(:unprocessable_content)
               expect(response.parsed_body.at_css("#confirmation_name_error").text).to include("must match")
               expect(person.reload).not_to be_permanently_removed
          end
          patch restore_user_path(person)
          expect(person.reload).not_to be_removed
     end

     it "hides the account permanently, erases credentials and preserves every contribution and its attribution" do
          person = users(:member)
          old_email = person.email
          work = [ Task, TaskAssignment, TimeEntry, TaskStatusChange, Membership ].to_h do |model|
               [ model, model.order(model.primary_key).map(&:attributes) ]
          end
          delete user_path(person)
          expect { delete permanently_remove_user_path(person), params: { confirmation_name: person.name } }.not_to change(User, :count)
          expect(response).to redirect_to(users_path(view: "removed"))
          expect(person.reload).to be_permanently_removed
          expect(person).to be_access_revoked
          expect(person.email).not_to eq(old_email)
          expect(person.password_digest).to be_nil
          expect(person.name).to eq("Morgan Member")
          work.each { |model, rows| expect(model.order(model.primary_key).map(&:attributes)).to eq(rows) }
          ApplicationRecord.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")

          %w[current removed].each do |view|
               [ person.name, old_email ].each do |query|
                    get users_path, params: { view: view, q: query }
                    expect(response.parsed_body.css("tbody th").map(&:text)).not_to include(person.name)
               end
          end
          get subteam_path(subteams(:wing))
          expect(response.parsed_body.at_css("[data-roster-member='#{person.id}']")).to be_nil
          get task_path(tasks(:wing_test))
          expect(response.body).to include("Morgan Member", "2.5 hours")
          get member_hours_report_path(format: :csv)
          expect(response.body).to include("Morgan Member", "2.5")
          get tasks_path
          expect(response.body).to include("Morgan Member")
          expect(User.task_candidates(teams(:aerodynamics).id, actor: users(:chief))).not_to include(person)

          [ :edit, :permanent_removal ].each do |action|
               get public_send("#{action}_user_path", person)
               expect(response).to have_http_status(:not_found)
          end
          patch restore_user_path(person)
          expect(response).to have_http_status(:not_found)
          patch user_path(person), params: { user: { role: "chief_engineer" } }
          expect(response).to have_http_status(:not_found)
          delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
          expect(response).to have_http_status(:not_found)
     end

     it "keeps old sessions blocked and lets a returning member receive a separate, empty account" do
          person = users(:member)
          old_email = person.email
          client = ActionDispatch::Integration::Session.new(Rails.application)
          client.post login_path, params: { email: old_email, password: "password" }
          stale_client = ActionDispatch::Integration::Session.new(Rails.application)
          stale_client.post login_path, params: { email: old_email, password: "password" }
          delete user_path(person)
          delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
          client.get tasks_path
          expect(client.response.location).to eq("http://www.example.com#{login_path}")
          client.post login_path, params: { email: old_email, password: "password" }
          expect(client.response.status).to eq(422)
          expect do
               post users_path, params: { user: { name: person.name, email: old_email, role: "member", subteam_id: subteams(:wing).id } }
          end.to change(User, :count).by(1)
          newcomer = User.find_by!(email: old_email)
          expect(newcomer.id).not_to eq(person.id)
          expect(newcomer.time_entries).to be_empty
          expect(newcomer.task_assignments).to be_empty
          expect(person.reload.time_entries.sum(:hours)).to eq(2.5)
          stale_client.get tasks_path
          expect(stale_client.response.location).to eq("http://www.example.com#{login_path}")
     end

     it "does not list permanently removed people without work in report cohorts or task filters" do
          person = User.create!(name: "Unused Account", email: "unused@tamu.edu", subteam: subteams(:wing))
          delete user_path(person)
          delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
          get tasks_path
          expect(response.parsed_body.css("[data-member-filter] option").map(&:text)).not_to include(person.name)
          expect(response.parsed_body.at_css("#hours").text).not_to include(person.name)
          get member_hours_report_path(format: :csv)
          expect(response.body).not_to include(person.name)
     end

     it "protects the active chief and denies officers, members and signed-out visitors" do
          delete permanently_remove_user_path(users(:chief)), params: { confirmation_name: users(:chief).name }
          expect(response).to have_http_status(:unprocessable_content)
          expect(users(:chief).reload).not_to be_permanently_removed
          person = users(:other_member)
          delete user_path(person)
          [ users(:officer), users(:member) ].each do |actor|
               sign_in(actor)
               get permanent_removal_user_path(person)
               expect(response).to redirect_to(root_path)
               delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
               expect(response).to redirect_to(root_path)
          end
          delete logout_path
          get permanent_removal_user_path(person)
          expect(response).to redirect_to(login_path)
          delete permanently_remove_user_path(person), params: { confirmation_name: person.name }
          expect(response).to redirect_to(login_path)
          expect(person.reload).not_to be_permanently_removed
     end

     it "preserves a former chief's cross-team assignments and assignment history" do
          former_chief = User.create!(name: "Former Chief", email: "former-chief@tamu.edu", role: :chief_engineer)
          tasks(:wing_test).assign_members([ users(:member).id, former_chief.id ], actor: former_chief)
          tasks(:spar_check).assign_members([ former_chief.id ], actor: former_chief)
          before_assignments = TaskAssignment.order(:id).map(&:attributes)
          delete user_path(former_chief)
          delete permanently_remove_user_path(former_chief), params: { confirmation_name: former_chief.name }
          expect(former_chief.reload).to be_permanently_removed
          expect(TaskAssignment.order(:id).map(&:attributes)).to eq(before_assignments)
          expect(users(:chief).reload).not_to be_access_revoked
          get member_hours_report_path(format: :csv)
          expect(response.body).to include("Former Chief", "All teams", "Chief Engineer")
     end

     it "reports an invalid legacy account without partially erasing its sign-in details" do
          person = users(:member)
          delete user_path(person)
          person.update_columns(name: "")
          saved = person.reload.attributes
          delete permanently_remove_user_path(person), params: { confirmation_name: "" }
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body.at_css(".error-summary").text).to include("Name can't be blank")
          expect(person.reload.attributes).to eq(saved)
     end
end
