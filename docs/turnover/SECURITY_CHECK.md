# Security check on the deployed release

Run by Joshua Eng on November 23, 2026 (Texas time) against the customer's production app `aero-task-hub`, release v33, commit `b236771`. Commands were run with Claude Code. No production record was changed: the logged-out requests carry no session and are refused before anything is saved, and the signed-in run blocks every database write. This replaces the November 17 check of release v27 and the earlier November 23 check of release v30: release v30 changed who can be assigned to a task and how people are removed, and release v33 records removal in the single access_revoked_at column.

Automated tests for the same rules, all passing in [CI run 45335416273](https://github.com/joshEng1/AERO-502/actions/runs/45335416273/job/138246229143): [Google sign-in](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/google_sign_in_spec.rb), [role access](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/role_access_spec.rb), [hours ownership](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/time_entry_management_spec.rb), [administrator handover](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/administrator_handover_spec.rb), [removing people](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/permanent_people_removal_spec.rb), [Chief Engineer self-assignment](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/requests/chief_self_assignment_spec.rb).

## Summary

| Check | Result |
| --- | --- |
| 1. Third-party (Google) sign-in works | **Pass.** A real Google sign-in on production succeeded on November 23 on release v30 (server log below). Release v33 did not change the sign-in route; its sign-in rules are covered by the 57 requests in section 3 and by the automated Google sign-in tests |
| 2. Logged-out visitors cannot read or change protected information | **Pass.** 18 protected pages redirect to the sign-in page; 9 change requests are refused |
| 3. A wrong role cannot read or change protected information | **Pass.** Member and officer were refused on every page and change reserved for another role, including removing and permanently removing a person |
| 4. Two accounts: changing the record number in the address does not expose, edit or delete another person's records | **Pass.** Member A was refused viewing, editing and deleting member B's hours entry and an unassigned task, and refused removing member B; the records were unchanged |
| Signed-in requests checked | 57, all as expected |

## 1. Google sign-in on production

Heroku application log, November 24, 2026 01:41 to 01:42 UTC, which is November 23, 7:41 p.m. in Texas, nine minutes after release v30 was created. Addresses, the Google code and state values are removed. The visitor selects **Sign in with Google**, Google returns to the callback, the app redirects to the home page and shows it.

```text
01:41:25 app[web.1]: Started POST "/auth/google_oauth2"
01:42:34 app[web.1]: Started GET "/auth/google_oauth2/callback?state=<removed>&iss=https://accounts.google.com&code=<removed>"
01:42:34 app[web.1]: Processing by SessionsController#omniauth as HTML
01:42:34 app[web.1]: Redirected to https://aero-task-hub-b5f4953964ed.herokuapp.com/
01:42:34 app[web.1]: Completed 302 Found in 26ms
01:42:35 app[web.1]: Started GET "/"
01:42:35 app[web.1]: Processing by TasksController#index as HTML
01:42:35 app[web.1]: Completed 200 OK in 272ms
```

Refused sign-ins are in section 3 (rows 1 and 2): an email that is not on the People list, and an approved email that Google has not verified, are both sent back to the sign-in page with "Access not authorized."

## 2. Logged-out requests

Sent with `curl` and no cookies on 2026-11-24 05:51 UTC (November 23, 11:51 p.m. CST), on release v33.

| Request | Response |
| --- | --- |
| `GET /login`, `GET /help` (member guide), `GET /up` | 200. These three pages are public by design |
| `GET /`, `/tasks`, `/tasks?view=mine`, `/tasks/1`, `/tasks/new`, `/timeline`, `/users`, `/users?view=removed`, `/users/4/removal`, `/users/4/permanent_removal`, `/organization`, `/subteams/1`, `/time_entries/1/edit`, `/tasks.csv` | 302 to `/login` (all 14) |
| `GET /help?guide=officer`, `/help?guide=chief`, `/help?guide=admin` | 302 to `/login` (all 3) |
| `GET /dashboard` (old address) | 301 to `/tasks#hours`, which then requires sign-in |
| `POST /tasks`, `PATCH /tasks/1`, `DELETE /tasks/1`, `POST /tasks/1/time_entries`, `DELETE /time_entries/1`, `POST /users`, `PATCH /users/1`, `DELETE /users/4`, `DELETE /users/4/permanently_remove` | 422 refused (all 9); nothing is saved |

## 3. Signed-in requests by role, including the two-account check

How it was run: a one-off process on the production app (`heroku run bin/rails runner`) sent each request through the deployed application code and the production database. Each account was signed in through the app's own Google callback with Google's answer simulated for that account in that process only; Google's own screen was not used here (section 1 covers the real one). `ActiveRecord::Base.while_preventing_writes` blocked every database write for the whole run. Run at 2026-11-24 05:50 UTC (November 23, 11:50 p.m. CST), on release v33.

Accounts and records, by number only:

```text
ACCOUNTS member A=user#70 (member, team#1); member B=user#4 (member); officer=user#2 (team#1); chief=user#1
RECORDS entry of B=time_entry#1; task not assigned to A=task#1; task assigned to A=task#233; other-team task=task#3 (team#2); officer's own-team task=task#1
```

"denied" means the app answered with a redirect and a refusal message, and for change requests that the record was read again and was unchanged.

| Who | Request | Expected | Response | Message shown | Result |
| --- | --- | --- | --- | --- | --- |
| unapproved Google account | `GET /auth/google_oauth2/callback` | denied | 302 to `/login` | Access not authorized. Ask the Chief Engineer to add your email to the allowed people list. | PASS |
| approved email, not verified by Google | `GET /auth/google_oauth2/callback` | denied | 302 to `/login` | Access not authorized. Ask the Chief Engineer to add your email to the allowed people list. | PASS |
| approved member, email in capitals | `GET /auth/google_oauth2/callback` | signed in | 302 to `/` | notice: Welcome back, <name>. | PASS |
| member A | `GET /` | ok | 200 page shown |  | PASS |
| member A | `GET /tasks?view=mine` | ok | 200 page shown |  | PASS |
| member A | `GET /tasks/233` | ok | 200 page shown |  | PASS |
| member A | `GET /tasks/1` | denied | 302 to `/` | You cannot view that task. | PASS |
| member A | `GET /tasks/1/edit` | denied | 302 to `/` | You can manage only tasks on your own team. | PASS |
| member A | `GET /time_entries/1/edit` | denied | 302 to `/` | You can change only your own hours. | PASS |
| member A | `PATCH /time_entries/1` | denied | 302 to `/` | You can change only your own hours. (record unchanged) | PASS |
| member A | `DELETE /time_entries/1` | denied | 302 to `/` | You can change only your own hours. (record unchanged) | PASS |
| member A | `POST /tasks/1/time_entries` | denied | 302 to `/` | You can record hours only on tasks assigned to you. (record unchanged) | PASS |
| member A | `PATCH /tasks/1` | denied | 302 to `/` | You can update only tasks assigned to you. (record unchanged) | PASS |
| member A | `GET /users` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| member A | `GET /users/new` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| member A | `GET /timeline` | denied | 302 to `/tasks` | Access denied. The timeline is available to team officers and the Chief Engineer. | PASS |
| member A | `GET /tasks/new` | denied | 302 to `/` | You are not authorized to perform that action. | PASS |
| member A | `GET /organization` | denied | 302 to `/` | You are not authorized to perform that action. | PASS |
| member A | `GET /tasks.csv` | denied | 302 to `/` | Access denied. Reports are available to team officers and the Chief Engineer. | PASS |
| member A | `GET /reports/member_hours.csv` | denied | 302 to `/` | Access denied. Reports are available to team officers and the Chief Engineer. | PASS |
| member A | `GET /reports/project_hours.csv` | denied | 302 to `/` | Access denied. Reports are available to team officers and the Chief Engineer. | PASS |
| member A | `GET /help?guide=officer` | denied | 302 to `/` | Access denied. The officer guide is available to team officers and the Chief Engineer. | PASS |
| member A | `GET /help?guide=chief` | denied | 302 to `/` | Access denied. The Chief Engineer guide is available to the Chief Engineer. | PASS |
| member A | `GET /help?guide=admin` | denied | 302 to `/` | Access denied. The administrator guide is available to the Chief Engineer. | PASS |
| member A | `GET /help/restart` | denied | 302 to `/` | Access denied. The administrator guide is available to the Chief Engineer. | PASS |
| member A | `GET /subteams/2` | denied | 302 to `/` | You are not authorized to perform that action. | PASS |
| member A | `PATCH /users/70` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| member A | `GET /users/4/removal` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| member A | `GET /users/4/permanent_removal` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| member A | `DELETE /users/4` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| member A | `DELETE /users/4/permanently_remove` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `GET /tasks` | ok | 200 page shown |  | PASS |
| officer | `GET /timeline` | ok | 200 page shown |  | PASS |
| officer | `GET /tasks/1` | ok | 200 page shown |  | PASS |
| officer | `GET /help?guide=officer` | ok | 200 page shown |  | PASS |
| officer | `GET /tasks/3` | denied | 302 to `/` | You cannot view that task. | PASS |
| officer | `GET /tasks/3/edit` | denied | 302 to `/` | You can manage only tasks on your own team. | PASS |
| officer | `PATCH /tasks/3` | denied | 302 to `/` | You can manage only tasks on your own team. (record unchanged) | PASS |
| officer | `GET /subteams/2` | denied | 302 to `/organization` | You can manage only your own team's subteams and projects. | PASS |
| officer | `GET /projects/35/edit` | denied | 302 to `/organization` | You can manage only your own team's subteams and projects. | PASS |
| officer | `GET /users` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| officer | `GET /help?guide=chief` | denied | 302 to `/` | Access denied. The Chief Engineer guide is available to the Chief Engineer. | PASS |
| officer | `GET /help?guide=admin` | denied | 302 to `/` | Access denied. The administrator guide is available to the Chief Engineer. | PASS |
| officer | `PATCH /users/70` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `PATCH /users/70/revoke` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `GET /users/4/permanent_removal` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| officer | `DELETE /users/4` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `DELETE /users/4/permanently_remove` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `GET /time_entries/1/edit` | denied | 302 to `/` | You can change only your own hours. | PASS |
| Chief Engineer | `GET /users` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /users?view=removed` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /timeline` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /organization` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /help?guide=chief` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /help?guide=admin` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /tasks/3` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /time_entries/1/edit` | denied | 302 to `/` | You can change only your own hours. | PASS |

```text
SNAPSHOT before: time_entries=10 (last change 2026-11-17T18:17:12.109745Z); tasks=16 (last change 2026-11-23T19:07:02.240092Z); users=12 (last change 2026-11-24T00:57:52.141399Z); task_assignments=17 (last change 2026-11-18T16:40:04.443260Z); task_status_changes=21; memberships=9; projects=8 (last change 2026-11-23T19:05:47.456683Z); subteams=9 (last change 2026-10-23T18:06:40.770064Z); teams=6 (last change 2026-11-17T16:20:23.416988Z)
SNAPSHOT after:  time_entries=10 (last change 2026-11-17T18:17:12.109745Z); tasks=16 (last change 2026-11-23T19:07:02.240092Z); users=12 (last change 2026-11-24T00:57:52.141399Z); task_assignments=17 (last change 2026-11-18T16:40:04.443260Z); task_status_changes=21; memberships=9; projects=8 (last change 2026-11-23T19:05:47.456683Z); subteams=9 (last change 2026-10-23T18:06:40.770064Z); teams=6 (last change 2026-11-17T16:20:23.416988Z)
DATABASE UNCHANGED; 57 pass, 0 fail
```

## The check script

```ruby
# Read-only access check run inside a one-off production dyno.
# Requests go through the deployed application code in-process. Sign-in is simulated per account
# (OmniAuth test mode in this process only). Database writes are blocked for the whole run.
require "action_dispatch/testing/integration"
Rails.logger.level = Logger::ERROR
OmniAuth.config.test_mode = true
OmniAuth.config.logger = Logger.new(IO::NULL)

HOST = "aero-task-hub-b5f4953964ed.herokuapp.com"
UA = { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36" }
RESULTS = []

def mock(email, verified: true)
     OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
          provider: "google_oauth2", uid: "turnover-check", info: { email: email },
          extra: { raw_info: { email_verified: verified } }
     )
end

def open_session(email = nil, verified: true)
     s = ActionDispatch::Integration::Session.new(Rails.application)
     s.host! HOST
     s.https!
     if email
          mock(email, verified: verified)
          s.get "/auth/google_oauth2/callback", headers: UA
     end
     s
end

def token(s)
     s.get "/help", headers: UA
     s.response.body[/name="csrf-token" content="([^"]+)"/, 1]
end

def record(actor, verb, path, expected, s, extra = nil)
     status = s.response.status
     location = s.response.headers["Location"].to_s.sub("https://#{HOST}", "")
     alert = s.flash[:alert].to_s rescue ""
     ok = case expected
     when :ok then status == 200
     when :denied then status == 302 && !alert.empty? && location != path
     end
     RESULTS << [ ok ? "PASS" : "FAIL", actor, "#{verb} #{path}", expected.to_s, status.to_s, location, alert, extra ].compact.join(" | ")
end

def get(actor, s, path, expected)
     s.get path, headers: UA
     record(actor, "GET", path, expected, s)
end

def write(actor, s, verb, path, params, expected, unchanged)
     before = unchanged.call
     s.public_send(verb, path, params: params.merge(authenticity_token: token(s)), headers: UA)
     same = unchanged.call == before
     record(actor, verb.to_s.upcase, path, expected, s, same ? "record unchanged" : "RECORD CHANGED")
end

def snapshot
     [ TimeEntry, Task, User, TaskAssignment, TaskStatusChange, Membership, Project, Subteam, Team ].map do |m|
          cols = m.column_names
          stamp = cols.include?("updated_at") ? m.maximum(:updated_at)&.utc&.iso8601(6) : nil
          "#{m.table_name}=#{m.count}#{stamp ? " (last change #{stamp})" : ""}"
     end.join("; ")
end

ActiveRecord::Base.while_preventing_writes(true) do
     before_all = snapshot
     active = User.where(access_revoked_at: nil)
     chief = active.chief_engineer.order(:id).first
     member_a = active.member.find_by(id: 70) || active.member.order(:id).last
     entry_b = TimeEntry.where.not(user_id: member_a.id).order(:id).first
     member_b = entry_b.user
     task_not_a = Task.where.not(id: member_a.assigned_tasks.select(:id)).order(:id).first
     task_a = member_a.assigned_tasks.order(:id).first
     officer = active.officer.joins(:membership).order(:id).first
     other_task = Task.joins(:project).where.not(projects: { team_id: officer.team_id }).order(:id).first
     own_task = Task.joins(:project).where(projects: { team_id: officer.team_id }).order(:id).first
     other_subteam = Subteam.where.not(team_id: officer.team_id).order(:id).first
     other_project = Project.where.not(team_id: officer.team_id).order(:id).first

     puts "ACCOUNTS member A=user##{member_a.id} (#{member_a.role}, team##{member_a.team_id}); member B=user##{member_b.id} (#{member_b.role}); " \
          "officer=user##{officer.id} (team##{officer.team_id}); chief=user##{chief.id}"
     puts "RECORDS entry of B=time_entry##{entry_b.id}; task not assigned to A=task##{task_not_a.id}; task assigned to A=#{task_a ? "task##{task_a.id}" : "none"}; " \
          "other-team task=task##{other_task.id} (team##{other_task.project.team_id}); officer's own-team task=#{own_task ? "task##{own_task.id}" : "none"}"

     # Sign-in outcomes
     s = open_session("not-on-the-list@example.test")
     record("unapproved Google account", "GET", "/auth/google_oauth2/callback", :denied, s)
     s = open_session(member_a.email, verified: false)
     record("approved email, not verified by Google", "GET", "/auth/google_oauth2/callback", :denied, s)
     s = open_session(member_a.email.upcase)
     RESULTS << [ (s.response.status == 302 && s.response.headers["Location"].to_s.end_with?("/") && s.flash[:notice].to_s.start_with?("Welcome back")) ? "PASS" : "FAIL",
                  "approved member, email in capitals", "GET /auth/google_oauth2/callback", "signed in", s.response.status.to_s, "/", "notice: Welcome back, <name>." ].join(" | ")

     # Member A
     a = open_session(member_a.email)
     get("member A", a, "/", :ok)
     get("member A", a, "/tasks?view=mine", :ok)
     get("member A", a, "/tasks/#{task_a.id}", :ok) if task_a
     get("member A", a, "/tasks/#{task_not_a.id}", :denied)
     get("member A", a, "/tasks/#{task_not_a.id}/edit", :denied)
     get("member A", a, "/time_entries/#{entry_b.id}/edit", :denied)
     entry_state = -> { TimeEntry.where(id: entry_b.id).pluck(:hours, :note, :worked_on, :updated_at) }
     write("member A", a, :patch, "/time_entries/#{entry_b.id}", { time_entry: { hours: "9" } }, :denied, entry_state)
     write("member A", a, :delete, "/time_entries/#{entry_b.id}", {}, :denied, entry_state)
     task_state = -> { [ Task.where(id: task_not_a.id).pluck(:status, :title, :updated_at), TimeEntry.where(task_id: task_not_a.id).count ] }
     write("member A", a, :post, "/tasks/#{task_not_a.id}/time_entries", { time_entry: { hours: "1", worked_on: Date.current.to_s } }, :denied, task_state)
     write("member A", a, :patch, "/tasks/#{task_not_a.id}", { task: { status: "completed" } }, :denied, task_state)
     %w[/users /users/new /timeline /tasks/new /organization /tasks.csv /reports/member_hours.csv /reports/project_hours.csv /help?guide=officer /help?guide=chief /help?guide=admin /help/restart].each do |path|
          get("member A", a, path, :denied)
     end
     get("member A", a, "/subteams/#{other_subteam.id}", :denied)
     user_state = -> { User.where(id: member_a.id).pluck(:role, :access_revoked_at, :updated_at) }
     write("member A", a, :patch, "/users/#{member_a.id}", { user: { role: "chief_engineer" } }, :denied, user_state)
     person_state = -> { [ User.where(id: member_b.id).pluck(:role, :access_revoked_at, :updated_at), User.count ] }
     get("member A", a, "/users/#{member_b.id}/removal", :denied)
     get("member A", a, "/users/#{member_b.id}/permanent_removal", :denied)
     write("member A", a, :delete, "/users/#{member_b.id}", {}, :denied, person_state)
     write("member A", a, :delete, "/users/#{member_b.id}/permanently_remove", {}, :denied, person_state)

     # Officer
     o = open_session(officer.email)
     get("officer", o, "/tasks", :ok)
     get("officer", o, "/timeline", :ok)
     get("officer", o, "/tasks/#{own_task.id}", :ok) if own_task
     get("officer", o, "/help?guide=officer", :ok)
     get("officer", o, "/tasks/#{other_task.id}", :denied)
     get("officer", o, "/tasks/#{other_task.id}/edit", :denied)
     other_state = -> { Task.where(id: other_task.id).pluck(:status, :title, :due_date, :updated_at) }
     write("officer", o, :patch, "/tasks/#{other_task.id}", { task: { title: "changed by another team" } }, :denied, other_state)
     get("officer", o, "/subteams/#{other_subteam.id}", :denied)
     get("officer", o, "/projects/#{other_project.id}/edit", :denied) if other_project
     get("officer", o, "/users", :denied)
     get("officer", o, "/help?guide=chief", :denied)
     get("officer", o, "/help?guide=admin", :denied)
     write("officer", o, :patch, "/users/#{member_a.id}", { user: { role: "chief_engineer" } }, :denied, user_state)
     write("officer", o, :patch, "/users/#{member_a.id}/revoke", {}, :denied, user_state)
     get("officer", o, "/users/#{member_b.id}/permanent_removal", :denied)
     write("officer", o, :delete, "/users/#{member_b.id}", {}, :denied, person_state)
     write("officer", o, :delete, "/users/#{member_b.id}/permanently_remove", {}, :denied, person_state)
     get("officer", o, "/time_entries/#{entry_b.id}/edit", :denied) unless entry_b.user_id == officer.id

     # Chief Engineer
     c = open_session(chief.email)
     %w[/users /users?view=removed /timeline /organization /help?guide=chief /help?guide=admin].each { |path| get("Chief Engineer", c, path, :ok) }
     get("Chief Engineer", c, "/tasks/#{other_task.id}", :ok)
     get("Chief Engineer", c, "/time_entries/#{entry_b.id}/edit", :denied) unless entry_b.user_id == chief.id

     puts RESULTS
     after_all = snapshot
     puts "SNAPSHOT before: #{before_all}"
     puts "SNAPSHOT after:  #{after_all}"
     puts "DATABASE #{before_all == after_all ? "UNCHANGED" : "CHANGED"}; #{RESULTS.count { |r| r.start_with?("PASS") }} pass, #{RESULTS.count { |r| r.start_with?("FAIL") }} fail"
end
```
