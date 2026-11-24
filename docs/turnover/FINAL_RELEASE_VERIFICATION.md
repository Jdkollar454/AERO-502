# Final release verification

Verified by Joshua Eng on November 23, 2026 (Texas time), using the GitHub and Heroku command-line tools from his workstation. Commands were run with Claude Code; the outputs below are copied from those runs. No production record was changed by any command in this file. This replaces the November 17 verification of release v27.

## Result

| Item | Value |
| --- | --- |
| Final tested application commit | [`b236771a5fb0ee9ecd953d9140ca025ec07236d5`](https://github.com/joshEng1/AERO-502/commit/b236771a5fb0ee9ecd953d9140ca025ec07236d5) on `main` (merge of pull request #58) |
| Required checks on that commit | [CI run 45335416273](https://github.com/joshEng1/AERO-502/actions/runs/45335416273): all four jobs passed |
| Commit deployed to the customer's app | `b236771a` |
| Heroku app and release | `aero-task-hub`, release **v33**, created 2026-11-24 05:47:26 UTC (November 23, 11:47 p.m. CST) |
| Tested commit = deployed commit? | **Yes.** The release description is `Deploy b236771a`, the same commit as the CI run |
| Database migrations in production | 20 of 20 `up`; none pending |
| Verifier and date | Joshua Eng, November 23, 2026 |
| Failing, disabled, skipped or missing required checks | **None on the final commit.** Two check problems on the way to it are disclosed under "Check problems and how they were resolved" |

This file and the other records in this folder were added to `main` by a later documentation commit. That commit changes guides and records only, no application code; its own commit, CI run and Heroku release are recorded in the turnover notebook, Section 2.5.

## Checks

The workflow [`.github/workflows/ci.yml`](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/.github/workflows/ci.yml) defines four required jobs. All four ran on the push of `b236771` to `main`.

| Job | What it runs | Result |
| --- | --- | --- |
| [test](https://github.com/joshEng1/AERO-502/actions/runs/45335416273/job/138246229143) | `bundle exec rspec` on Ruby 4.0.10 and PostgreSQL 16 with Chrome for browser tests | **297 examples, 0 failures** (1 min 34 s); line coverage 1151 / 1151, branch coverage 435 / 435. SimpleCov's 100% line and branch minimums are enforced by the suite |
| [lint](https://github.com/joshEng1/AERO-502/actions/runs/45335416273/job/138246229102) | `bin/rubocop` | Passed |
| [scan_ruby](https://github.com/joshEng1/AERO-502/actions/runs/45335416273/job/138246228835) | `bin/brakeman --no-pager` | Passed |
| [scan_js](https://github.com/joshEng1/AERO-502/actions/runs/45335416273/job/138246229111) | `bin/importmap audit` | Passed |

No job is disabled, skipped or marked allowed-to-fail in the workflow file. The same four commands were repeated in a clone of `b236771` on November 23 with Ruby 4.0.10: 297 examples, 0 failures, line coverage 1151 / 1151 and branch coverage 435 / 435; Brakeman 8.1.1 reported 0 warnings; RuboCop inspected 137 files with no offenses; the import map audit found no vulnerable packages. The per-test outcomes are in [the test results](TEST_RESULTS.md).

## Check problems and how they were resolved

| Problem | What was done | Result |
| --- | --- | --- |
| Releases **v28 and v29** (November 19) were deployed to production directly from the branch `feature/chief-assignment-people-dark-mode` (commits `9901a5e` and `45fb869`), before a pull request existed. CI runs only on pull requests and on pushes to `main`, `test` and `dev`, so no check ran on those two releases. | The same commits were put through [pull request #51](https://github.com/joshEng1/AERO-502/pull/51) on November 23, and `main` was deployed again. | Release v30 came from `main` after a passing CI run, so production and `main` matched again; every release since then has come from `main` |
| The first CI run on pull request #51, [run 45303798245](https://github.com/joshEng1/AERO-502/actions/runs/45303798245), **failed the `scan_ruby` job** ([log](https://github.com/joshEng1/AERO-502/actions/runs/45303798245/job/138142550931)): `bin/brakeman` stops when a newer Brakeman exists ("Brakeman 8.1.0 is not the latest version 8.1.1"). The other three jobs passed. | [Commit `1d4a71a`](https://github.com/joshEng1/AERO-502/commit/1d4a71a4a18bb01cde55c60848938cbee6308b65) updated Brakeman to 8.1.1. Brakeman 8.1.1 then reported a critical vulnerability in Ruby 4.0.6 and asked for 4.0.10 or later, so the same commit moved Ruby to 4.0.10 and Rails from 8.1.4 to 8.1.4.1 (which brings nokogiri 1.19.7 and loofah 2.25.3). | [Run 45304954011](https://github.com/joshEng1/AERO-502/actions/runs/45304954011) on the pull request: all four jobs passed. [Run 45305381239](https://github.com/joshEng1/AERO-502/actions/runs/45305381239) on `main` after the merge: all four passed |

## Deployment log

`heroku releases -a aero-task-hub -n 6` (account names removed):

```text
=== aero-task-hub Releases - Current: v33
 v33   Deploy b236771a   2026/11/23 23:47:26 -0600
 v32   Deploy 9468f01b   2026/11/23 22:57:22 -0600
 v31   Deploy 9468f01b   2026/11/23 20:24:19 -0600
 v30   Deploy 9faa5b95   2026/11/23 19:32:32 -0600
 v29   Deploy 45fb869c   2026/11/19 14:06:57 -0600
 v28   Deploy 9901a5ea   2026/11/19 13:40:24 -0600
 v27   Deploy 3417e8a0   2026/11/17 00:07:03 -0600
```

`heroku releases:info v33 -a aero-task-hub`:

```text
=== Release v33
Add-ons:                heroku-postgresql:essential-0
Change:                 Deploy b236771a
Eligible for Rollback?: Yes
When:                   2026-11-24T05:47:26Z
```

Pull request #58 was merged at 05:44:25 UTC, the CI run on `main` finished at 05:46:46 UTC, and Heroku created release v33 at 05:47:26 UTC. Heroku deploys `main` automatically and waits for CI to pass.

| Release | Commit | CI run |
| --- | --- | --- |
| v27 | `3417e8a` (pull request #50) | [44028487061](https://github.com/joshEng1/AERO-502/actions/runs/44028487061) on `main`, success |
| v28 | `9901a5e` (feature branch) | none; see the table above |
| v29 | `45fb869` (feature branch) | none; see the table above |
| v30 | `9faa5b9` (pull request #51) | [45305381239](https://github.com/joshEng1/AERO-502/actions/runs/45305381239) on `main`, success |
| v31 | `9468f01` (pull request #52, records and guides only) | [45311503670](https://github.com/joshEng1/AERO-502/actions/runs/45311503670) on `main`, success |
| v32 | `9468f01` again, deployed from the Heroku dashboard after the repository transfer | same commit as v31 |
| v33 | `b236771` (pull request #58) | [45335416273](https://github.com/joshEng1/AERO-502/actions/runs/45335416273) on `main`, success |

## Database migration on the deployment platform

`heroku run bin/rails db:migrate:status -a aero-task-hub`, run November 23, 2026 against release v33:

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
   up     20261119120000  Add removal to users
   up     20261119121000  Allow chief engineer assignments
   up     20261119180000  Add permanent removal to users
   up     20261124030000  Merge removal into access revoked
```

These are the same 20 files as [`db/migrate`](https://github.com/joshEng1/AERO-502/tree/b236771a5fb0ee9ecd953d9140ca025ec07236d5/db/migrate) at the deployed commit. Three were added on November 19 for the customer's two final requests, and the last one on November 23 folds `removed_at` into the approved `access_revoked_at` column.

## Delivered database compared with the submitted schema

A read-only query in a one-off production process listed every table with its columns and foreign keys. The result was compared with [`db/structure.sql`](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/db/structure.sql) at the deployed commit.

| Table | Columns in production (same names and order as `db/structure.sql`) | Foreign keys |
| --- | --- | ---: |
| teams | id, name, created_at, updated_at, archived_at | 0 |
| subteams | id, name, team_id, created_at, updated_at, archived_at | 1 |
| projects | id, name, created_at, updated_at, archived_at, team_id | 1 |
| users | id, name, email, password_digest, created_at, updated_at, access_revoked_at, role, permanently_removed_at | 0 |
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
| Migration versions recorded | 20 | 20 |
| Pending migrations | n/a | none |

Compared with release v27, the only table that changed is `users`, which gained `permanently_removed_at`. A second column, `removed_at`, existed from release v28 to v32 and was folded into `access_revoked_at` in v33. Production also reported PostgreSQL 18.4, Rails 8.1.4.1 and Ruby 4.0.10.

## Configuration names present on the app

`DATABASE_URL`, `SECRET_KEY_BASE`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `PASSWORD_SIGN_IN`, `DEMO_PASSWORD`. Values are not recorded anywhere in this repository.

## Hosting state on November 23, 2026

- Heroku owner: JD Kollar (customer), since the evening of November 23. Collaborators: three development-team accounts.
- GitHub: the repository was transferred to JD Kollar on November 23 and is now `Jdkollar454/AERO-502`; the earlier address, `joshEng1/AERO-502`, redirects to it. The development team has write access.
- Plans: one Eco web dyno and Heroku Postgres Essential-0.
- Backups: an automatic backup runs daily at 2:00 a.m. Central time (`a011` to `a014`, November 20 to 23, each completed). Manual backups: `b010` on November 19 just before release v29, and `b015` on November 23 just before release v33. The restore rehearsal of November 17 is in [the recovery check](RECOVERY_CHECK.md).
- Password sign-in for practice accounts is still enabled (`PASSWORD_SIGN_IN` is not `off`). The People table holds 12 accounts: 3 Chief Engineers, 4 officers and 5 members, of which 6 are practice accounts. JD Kollar has a Chief Engineer account.
- The staging app `aero-task-hub-staging` still runs commit `3417e8a`; releases v30 to v33 were not deployed to staging. See [the staging check](STAGING_CHECK.md).

## Response times observed in production

Measured on November 17, 2026 on release v27 and not measured again. Releases v30 and v33 changed the People screens and the assignment rule, not the pages measured here.

Taken from the Heroku router log for 128 successful page requests on November 17, 2026 (sign-in, task board, My Tasks, task pages, hour entries, Help and Teams), with 11 people, 14 tasks and 10 hour entries in the database.

| Measure | Server time per request |
| --- | ---: |
| Median | 37 ms |
| 95th percentile | 347 ms |
| Slowest | 682 ms |
| Task page (21 requests), median | 61 ms |
| Task board (18 requests), median | 55 ms |
| Saving an hours entry (10 requests), median | 37 ms |

The first request after the Eco dyno has been asleep took about 8 seconds (`/up`, measured once). This is a record of normal use, not a load test. The member picker is tested separately with 80 members in [`spec/system/member_selector_spec.rb`](https://github.com/joshEng1/AERO-502/blob/b236771a5fb0ee9ecd953d9140ca025ec07236d5/spec/system/member_selector_spec.rb).
