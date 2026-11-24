# Staging deployment check

> **Status on November 23, 2026:** this is the record of the staging check made on November 17 for commit `3417e8a`. The staging app `aero-task-hub-staging` still runs that commit. Release v30 (`9faa5b9`) went to production through pull request #51 and CI and was not deployed to staging first.

Run by Joshua Eng on November 17, 2026 (Texas time), with Claude Code. The earlier staging app, `protected-beyond-83306`, last received the `test` branch on November 3 and its address now answers "No such app"; it belonged to another account. A new staging app was created in Joshua's Heroku account for this check.

| Item | Value |
| --- | --- |
| Staging app | `aero-task-hub-staging`, https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/ |
| Commit deployed | `3417e8a0e7fe8c24b193a5a91dc2ad41421662e8`, the same commit as production release v27 |
| Staging release | v5, "Deploy 3417e8a0", 2026-11-18 03:44 UTC (November 17, 9:44 p.m. CST) |
| Plans | One Eco web dyno; Heroku Postgres Essential-0 (its own database, separate from production; up to $5 a month) |
| Database | PostgreSQL 18.4; 16 of 16 migrations `up`, none pending |
| Data | Practice data only, from `bin/rails db:seed`: 3 classes, 7 subteams, 7 projects, 6 practice accounts, 3 tasks, 3 hour entries. No production record was copied |
| Sign-in | Practice accounts with the password form. Google sign-in is not configured on staging, because its address is not registered with the Google client; the real Google sign-in is checked on production in [the security check](SECURITY_CHECK.md) |
| Settings present (names only) | `DATABASE_URL`, `SECRET_KEY_BASE`, `DEMO_PASSWORD` |

## Result

| Check | Result |
| --- | --- |
| Health page, sign-in page and member guide open | Pass |
| Protected pages without signing in | Pass: all redirect to the sign-in page |
| A practice member signs in and opens My Tasks | Pass: "Welcome back, Morgan Member"; My Tasks shown |
| A member opens People | Pass: refused |
| Role and two-account checks (the same 49 requests as on production) | Pass: 49 of 49 as expected; database unchanged |

## Requests sent from outside

2026-11-18 03:45 UTC.

```text
== logged out
GET /up                200 -> 
GET /login             200 -> 
GET /help              200 -> 
GET /                  302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
GET /tasks             302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
GET /users             302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
GET /timeline          302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
GET /tasks/1           302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
GET /help?guide=admin  302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/login
== practice sign-in (password form)
member.a sign-in: 302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/
home: Welcome back, Morgan Member
My Tasks: 200 <h1>My Tasks</h1>
member opens /users: 302 -> https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/
Google button: 200 login page; Google sign-in is not configured on staging
```

## Signed-in requests by role

Run inside a one-off process of the staging app, the same way as on production: each account is signed in through the app's own callback with the sign-in reply simulated, and database writes are blocked for the run.

```text
ACCOUNTS member A=user#6 (member, team#2); member B=user#4 (member); officer=user#2 (team#1); chief=user#1
RECORDS entry of B=time_entry#1; task not assigned to A=task#1; task assigned to A=task#3; other-team task=task#3 (team#2); officer's own-team task=task#1
```

| Who | Request | Expected | Response | Message shown | Result |
| --- | --- | --- | --- | --- | --- |
| unapproved Google account | `GET /auth/google_oauth2/callback` | denied | 302 to `/login` | Access not authorized. Ask the Chief Engineer to add your email to the allowed people list. | PASS |
| approved email, not verified by Google | `GET /auth/google_oauth2/callback` | denied | 302 to `/login` | Access not authorized. Ask the Chief Engineer to add your email to the allowed people list. | PASS |
| approved member, email in capitals | `GET /auth/google_oauth2/callback` | signed in | 302 to `/` | notice: Welcome back, <name>. | PASS |
| member A | `GET /` | ok | 200 page shown |  | PASS |
| member A | `GET /tasks?view=mine` | ok | 200 page shown |  | PASS |
| member A | `GET /tasks/3` | ok | 200 page shown |  | PASS |
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
| member A | `GET /subteams/3` | denied | 302 to `/` | You are not authorized to perform that action. | PASS |
| member A | `PATCH /users/6` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `GET /tasks` | ok | 200 page shown |  | PASS |
| officer | `GET /timeline` | ok | 200 page shown |  | PASS |
| officer | `GET /tasks/1` | ok | 200 page shown |  | PASS |
| officer | `GET /help?guide=officer` | ok | 200 page shown |  | PASS |
| officer | `GET /tasks/3` | denied | 302 to `/` | You cannot view that task. | PASS |
| officer | `GET /tasks/3/edit` | denied | 302 to `/` | You can manage only tasks on your own team. | PASS |
| officer | `PATCH /tasks/3` | denied | 302 to `/` | You can manage only tasks on your own team. (record unchanged) | PASS |
| officer | `GET /subteams/3` | denied | 302 to `/organization` | You can manage only your own team's subteams and projects. | PASS |
| officer | `GET /projects/3/edit` | denied | 302 to `/organization` | You can manage only your own team's subteams and projects. | PASS |
| officer | `GET /users` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. | PASS |
| officer | `GET /help?guide=chief` | denied | 302 to `/` | Access denied. The Chief Engineer guide is available to the Chief Engineer. | PASS |
| officer | `GET /help?guide=admin` | denied | 302 to `/` | Access denied. The administrator guide is available to the Chief Engineer. | PASS |
| officer | `PATCH /users/6` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `PATCH /users/6/revoke` | denied | 302 to `/` | Access denied. Only the Chief Engineer can manage people and roles. (record unchanged) | PASS |
| officer | `GET /time_entries/1/edit` | denied | 302 to `/` | You can change only your own hours. | PASS |
| Chief Engineer | `GET /users` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /timeline` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /organization` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /help?guide=chief` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /help?guide=admin` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /tasks/3` | ok | 200 page shown |  | PASS |
| Chief Engineer | `GET /time_entries/1/edit` | denied | 302 to `/` | You can change only your own hours. | PASS |

```text
SNAPSHOT before: time_entries=3 (last change 2026-11-18T03:44:41.050596Z); tasks=3 (last change 2026-11-18T03:44:40.959225Z); users=6 (last change 2026-11-18T03:44:40.669587Z); task_assignments=4 (last change 2026-11-18T03:44:40.988373Z); task_status_changes=3; memberships=5; projects=7 (last change 2026-11-18T03:44:38.874426Z); subteams=7 (last change 2026-11-18T03:44:38.854930Z); teams=3 (last change 2026-11-18T03:44:38.742182Z)
SNAPSHOT after:  time_entries=3 (last change 2026-11-18T03:44:41.050596Z); tasks=3 (last change 2026-11-18T03:44:40.959225Z); users=6 (last change 2026-11-18T03:44:40.669587Z); task_assignments=4 (last change 2026-11-18T03:44:40.988373Z); task_status_changes=3; memberships=5; projects=7 (last change 2026-11-18T03:44:38.874426Z); subteams=7 (last change 2026-11-18T03:44:38.854930Z); teams=3 (last change 2026-11-18T03:44:38.742182Z)
DATABASE UNCHANGED; 49 pass, 0 fail
```

## Keeping staging current

Staging does not deploy automatically. To put a commit on it, push that commit to the staging app's Heroku Git address as `main`, for example `git push https://git.heroku.com/aero-task-hub-staging.git COMMIT:main`, then check the release with `heroku releases -a aero-task-hub-staging`. Reload the practice data with `heroku run bin/rails db:seed -a aero-task-hub-staging`. The practice password is the staging app's `DEMO_PASSWORD` setting.
