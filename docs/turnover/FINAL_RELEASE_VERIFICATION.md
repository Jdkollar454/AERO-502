# Final release verification

Verified by Joshua Eng on November 17, 2026 (Texas time), using the GitHub and Heroku command-line tools from his workstation. Commands were run with Claude Code; the outputs below are copied from those runs. No production record was changed by any command in this file.

## Result

| Item | Value |
| --- | --- |
| Final tested commit | [`3417e8a0e7fe8c24b193a5a91dc2ad41421662e8`](https://github.com/joshEng1/AERO-502/commit/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8) on `main` (merge of pull request #50) |
| Required checks on that commit | [CI run 44028487061](https://github.com/joshEng1/AERO-502/actions/runs/44028487061): all four jobs passed |
| Commit deployed to the customer's app | `3417e8a0` |
| Heroku app and release | `aero-task-hub`, release **v27**, created 2026-11-17 06:07:03 UTC (12:07 a.m. CST) |
| Tested commit = deployed commit? | **Yes.** The release description is `Deploy 3417e8a0`, the same commit as the CI run |
| Database migrations in production | 16 of 16 `up`; none pending |
| Verifier and date | Joshua Eng, November 17, 2026 |
| Failing, disabled, skipped or missing required checks | **None.** See "Checks" below |

## Checks

The workflow [`.github/workflows/ci.yml`](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/.github/workflows/ci.yml) defines four required jobs. All four ran on the push of `3417e8a` to `main`.

| Job | What it runs | Result |
| --- | --- | --- |
| [test](https://github.com/joshEng1/AERO-502/actions/runs/44028487061/job/133854450396) | `bundle exec rspec` on PostgreSQL 16 with Chrome for browser tests | **263 examples, 0 failures** (1 min 21 s). SimpleCov's 100% line and branch minimums are enforced by the suite, so a pass means both held |
| [lint](https://github.com/joshEng1/AERO-502/actions/runs/44028487061/job/133854450275) | `bin/rubocop` | Passed |
| [scan_ruby](https://github.com/joshEng1/AERO-502/actions/runs/44028487061/job/133854449900) | `bin/brakeman --no-pager` | Passed |
| [scan_js](https://github.com/joshEng1/AERO-502/actions/runs/44028487061/job/133854450472) | `bin/importmap audit` | Passed |

No job is disabled, skipped or marked allowed-to-fail in the workflow file. The same four commands were repeated in a fresh clone of `3417e8a` on November 17 (see [the developer instruction check](DEVELOPER_INSTRUCTION_CHECK.md) and [the per-test results](TEST_RESULTS.md)): 263 examples, 0 failures, line coverage 1088 / 1088 and branch coverage 399 / 399; RuboCop 127 files, no offenses; Brakeman 0 errors and 0 warnings; no vulnerable JavaScript packages.

One process exception is disclosed: pull requests #48, #49 and #50 were merged into `main` with passing CI but without an approving review.

## Deployment log

`heroku releases -a aero-task-hub -n 12` (account names removed):

```text
=== aero-task-hub Releases - Current: v27
 v27   Deploy 3417e8a0   2026/11/17 00:07:03 -0600
 v26   Deploy ee2fe921   2026/11/16 23:56:16 -0600
 v25   Deploy 7ea0b92e   2026/11/16 23:30:51 -0600
 v24   Deploy cbdf7a05   2026/11/02 22:46:07 -0600
 v23   Deploy 2e4df57e   2026/11/02 19:19:50 -0600
 v22   Set GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, PASSWORD_SIGN_IN, SECRET_KEY_BASE config vars, remove RAILS_MASTER_KEY config vars   2026/11/02 19:12:02 -0600
 v21   Deploy 0302c5ee   2026/11/02 18:54:38 -0600
```

`heroku releases:info v27 -a aero-task-hub`:

```text
=== Release v27
Add-ons:                heroku-postgresql:essential-0
Change:                 Deploy 3417e8a0
Eligible for Rollback?: Yes
When:                   2026-11-17T06:07:03Z
```

Each of v25, v26 and v27 was created a few minutes after the matching pull request was merged into `main` and its CI run finished (for v27: CI finished 06:06:27 UTC, release created 06:07:03 UTC).

| Release | Commit | CI run on `main` |
| --- | --- | --- |
| v25 | `7ea0b92` (pull request #48) | [44024305266](https://github.com/joshEng1/AERO-502/actions/runs/44024305266), success |
| v26 | `ee2fe92` (pull request #49) | [44027237126](https://github.com/joshEng1/AERO-502/actions/runs/44027237126), success |
| v27 | `3417e8a` (pull request #50) | [44028487061](https://github.com/joshEng1/AERO-502/actions/runs/44028487061), success |

## Database migration on the deployment platform

`heroku run bin/rails db:migrate:status -a aero-task-hub`, run November 17, 2026 against release v27:

```text
database: (name removed)

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20260927224355  Create projects
   up     20260927224356  Create teams
   up     20260927224357  Create subteams
   up     20260927224358  Create users
   up     20260927224359  Create tasks
   up     20260927224360  Create task assignments
   up     20260927224361  Create time entries
   up     20261007120000  Add dates and links to tasks
   up     20261007130000  Create task events
   up     20261007140000  Add archiving and user subteams
   up     20261007150000  Add subject user to task events
   up     20261007160000  Allow google only users
   up     20261007170000  Nest projects under subteams
   up     20261023120000  Share projects and record memberships
   up     20261023121000  Normalize user membership identity
   up     20261102000000  Align approved sprint three design
```

These are the same 16 files as [`db/migrate`](https://github.com/joshEng1/AERO-502/tree/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/db/migrate) at the deployed commit.

## Delivered database compared with the submitted schema

A read-only query in a one-off production process listed every table with its columns and foreign keys. The result was compared with [`db/structure.sql`](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/db/structure.sql) at the deployed commit.

| Table | Columns in production (same names and order as `db/structure.sql`) | Foreign keys |
| --- | --- | ---: |
| teams | id, name, created_at, updated_at, archived_at | 0 |
| subteams | id, name, team_id, created_at, updated_at, archived_at | 1 |
| projects | id, name, created_at, updated_at, archived_at, team_id | 1 |
| users | id, name, email, password_digest, created_at, updated_at, access_revoked_at, role | 0 |
| memberships | user_id, subteam_id | 2 |
| tasks | id, title, description, instructions, due_date, estimated_hours, status, creator_id, created_at, updated_at, start_date, project_id | 2 |
| task_assignments | id, task_id, user_id, created_at, updated_at, assigned_by_id, unassigned_by_id, assigned_at, unassigned_at, is_primary_contact | 4 |
| time_entries | id, task_id, user_id, hours, note, worked_on, created_at, updated_at | 2 |
| task_status_changes | id, task_id, actor_id, to_status, created_at | 2 |
| task_dependencies | task_id, prerequisite_task_id | 2 |
| schema_migrations (Rails) | version | 0 |
| ar_internal_metadata (Rails) | key, value, created_at, updated_at | 0 |

| Measure | `db/structure.sql` | Production |
| --- | ---: | ---: |
| Tables | 12 | 12 |
| Tables whose column list matches exactly | 12 | 12 |
| Foreign keys | 16 | 16 |
| Triggers | 18 | 18 |
| Migration versions recorded | 16 | 16 |
| Pending migrations | n/a | none |

Production also reported PostgreSQL 18.4, Rails 8.1.4 and Ruby 4.0.6.

## Configuration names present on the app

`DATABASE_URL`, `SECRET_KEY_BASE`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `PASSWORD_SIGN_IN`, `DEMO_PASSWORD`. Values are not recorded anywhere in this repository.

## Hosting state on November 17, 2026

- Heroku owner: Joshua Eng's account. Collaborators: JD Kollar (customer), Sonny Hernandez and Rahul Saravanakumar. Ownership transfer to the customer has **not** happened yet.
- Plans: one Eco web dyno and Heroku Postgres Essential-0.
- Backups on the app: `b005` (2026-11-17 05:19 UTC, before release v25), `b003` and `b002` (2026-11-03), `b001` (2026-11-02). No backup schedule is configured (`heroku pg:backups:schedules` reports none).
- Password sign-in for practice accounts is still enabled (`PASSWORD_SIGN_IN` is not `off`). The People list holds 11 accounts: 3 Chief Engineers, 3 officers and 5 members, of which 6 are practice accounts. JD Kollar has a Chief Engineer account.
- The earlier practice (staging) app at `protected-beyond-83306` no longer exists; its address returned 404 on November 17.

## Response times observed in production

Taken from the Heroku router log for 128 successful page requests on November 17, 2026 (sign-in, task board, My Tasks, task pages, hour entries, Help and Teams), with 11 people, 14 tasks and 10 hour entries in the database.

| Measure | Server time per request |
| --- | ---: |
| Median | 37 ms |
| 95th percentile | 347 ms |
| Slowest | 682 ms |
| Task page (21 requests), median | 61 ms |
| Task board (18 requests), median | 55 ms |
| Saving an hours entry (10 requests), median | 37 ms |

The first request after the Eco dyno has been asleep took about 8 seconds (`/up`, measured once). This is a record of normal use, not a load test. The member picker is tested separately with 80 members in [`spec/system/member_selector_spec.rb`](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/system/member_selector_spec.rb).
