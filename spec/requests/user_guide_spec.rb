require "rails_helper"

# KAN-17 / scope S15 / UAT D2: guides people can open from the website, one tab per role.
RSpec.describe "User guide", type: :request do
     it "D2.7: is linked from the header and from the sign-in page" do
          get login_path
          expect(response.parsed_body.at_css("a[href='#{help_path}']")).to be_present

          sign_in(users(:member))
          get tasks_path
          expect(response.parsed_body.at_css("header a[href='#{help_path}']").text).to eq("Help")
     end

     it "opens without signing in so people who cannot sign in can read what to do" do
          get help_path

          expect(response).to have_http_status(:ok)
          headings = response.parsed_body.css("main h2").map(&:text)
          expect(headings).to include("Sign in", "Record actual hours", "Messages and what to do")
     end

     # Each guide's text as the Chief Engineer, who may read all of them.
     def guide_text(guide = nil)
          get help_path(guide: guide)
          response.parsed_body.at_css("main .guide").text.squish
     end

     it "D2.6: explains every message the website shows, with a next step, in the guide for the role that can meet it" do
          sign_in(users(:chief))

          {
               nil => [
                    "Access not authorized", "Your access has been removed", "Please sign in to view that page",
                    "Hours must be a number, such as 1 or 2.5", "Hours must be more than 0",
                    "The most for one day is 24 hours", "Date worked can't be blank",
                    "You can record hours only on tasks assigned to you.",
                    "Members may update only the status of their assigned tasks.",
                    "You can update only tasks assigned to you.", "You cannot view that task.",
                    "You can change only your own hours.",
                    "The timeline is available to team officers and the Chief Engineer.",
                    "Only the Chief Engineer can manage people and roles.",
                    "The officer guide is available to team officers and the Chief Engineer.",
                    "The Chief Engineer guide is available to the Chief Engineer.",
                    "Google sign-in was cancelled or failed"
               ],
               "officer" => [
                    "Title can't be blank", "Estimated hours is not a number",
                    "Due date must be on or after the start date", "End date must be on or after the start date",
                    "is not a valid date", "must each be a full web address starting with http:// or https://",
                    TasksController::OWN_TEAM_ONLY, "You can manage only your own team's subteams and projects.",
                    "Name has already been taken", "Primary contact must be an active assignee"
               ],
               "chief" => [
                    "At least one active Chief Engineer is required.", "Subteam is required for a member or officer",
                    "Email has already been taken", "Email is invalid"
               ]
          }.each do |guide, messages|
               text = guide_text(guide)
               messages.each { |message| expect(text).to include(message), "#{guide || 'member'} guide lacks #{message}" }
          end
     end

     it "keeps each role's steps in its own guide" do
          sign_in(users(:chief))
          member, officer, chief = guide_text, guide_text("officer"), guide_text("chief")

          expect(member).to include("Record actual hours", "Correct or delete your hours")
          expect(member).not_to include("Create or edit a task", "Subteam rosters", "Add person")
          expect(officer).to include("Create or edit a task", "Subteam rosters", "Download reports", "Additional teams")
          expect(officer).not_to include("Record actual hours", "Add person")
          expect(chief).to include("Add person", "Change role", "Restrict access", "Remove person")
          expect(chief).not_to include("Create or edit a task", "Record actual hours")
     end

     it "shows each role only the tabs for its own guides, marking the open one" do
          tabs = -> { response.parsed_body.css(".guide-tabs .guide-tab").map(&:text) }

          get help_path
          expect(tabs.call).to eq([ "Member guide" ])

          sign_in(users(:member))
          get help_path
          expect(tabs.call).to eq([ "Member guide" ])

          sign_in(users(:officer))
          get help_path(guide: "officer")
          expect(tabs.call).to eq([ "Member guide", "Officer guide" ])
          expect(response.parsed_body.at_css(".guide-tab[aria-current=page]").text).to eq("Officer guide")
          expect(response.parsed_body.at_css("title").text).to include("Officer guide")

          sign_in(users(:chief))
          get help_path(guide: "chief")
          expect(tabs.call).to eq([ "Member guide", "Officer guide", "Chief Engineer guide", "Administrator guide" ])
          expect(response.parsed_body.at_css(".guide-tab[aria-current=page]").text).to eq("Chief Engineer guide")
     end

     it "refuses a guide to a role that has no tab for it, and falls back to the member guide for an unknown name" do
          [ "officer", "chief" ].each do |guide|
               get help_path(guide: guide)
               expect(response).to redirect_to(login_path)
          end

          sign_in(users(:member))
          get help_path(guide: "officer")
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("Access denied. The officer guide is available to team officers and the Chief Engineer.")

          sign_in(users(:officer))
          get help_path(guide: "chief")
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("Access denied. The Chief Engineer guide is available to the Chief Engineer.")

          get help_path(guide: "nonsense")
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.at_css(".guide-tab[aria-current=page]").text).to eq("Member guide")
     end

     it "D2.3: contains no passwords and renders as safe HTML" do
          get help_path

          expect(response.body).not_to include(ENV.fetch("DEMO_PASSWORD", "AeroSprint1!"))
          expect(response.parsed_body.css("main script")).to be_empty
          expect(response.parsed_body.css("main table")).to be_present
     end
end
