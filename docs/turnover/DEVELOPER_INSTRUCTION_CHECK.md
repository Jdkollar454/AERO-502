# Developer instruction check

**Who:** Joshua Eng. **When:** November 17, 2026 (Texas time). **Where:** his workstation, Windows 11 with WSL2 Ubuntu 24.04, Ruby 4.0.6, Bundler 4.0.16, PostgreSQL 16.15. The commands were typed and their output collected with Claude Code.

**What was used:** the README sections **Installation and Setup**, **Running the Application** and **Tests** at commit [`3417e8a`](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/README.md#installation-and-setup), followed step by step in a new empty folder, and the recovery sections of the [administrator guide](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/docs/ADMIN_GUIDE.md). Joshua wrote the current README, so a second pass by Sonny Hernandez, who did not write it, is still worth doing; it is listed as an open item in the turnover notebook.

## First pass: setting up the app from the instructions

| README step | What was done | Result |
| --- | --- | --- |
| 1. Install Git, Ruby 4.0.6, PostgreSQL | Already installed; versions above | OK |
| 2. Get the code | `git clone https://github.com/joshEng1/AERO-502.git` into an empty folder | Clone is at `3417e8a` |
| 3. Configure a separate local database | The step does not say how. Nothing was configured; the default `config/database.yml` was left as it is | **Unclear** (gap 1) |
| 4. `bundle install` | Run as written | Dependencies satisfied |
| 4. `bin/rails db:prepare` | Run as written | `Created database 'aero_502_development'`, then `Seeded SAE AERO practice data.` (6 s) |
| 4. `bin/rails db:seed` | Run as written | `Seeded SAE AERO practice data.` 3 classes, 7 subteams, 7 projects, 6 practice accounts, 3 tasks |
| 4. Practice password: "ask the team for it" | With `DEMO_PASSWORD` unset, the seed used its built-in practice default, which the README does not mention | **Unclear** (gap 2) |
| Running: `bin/rails server` | Started on port 3000 | `/up` returned 200 |
| Running: sign in with a practice account | Signed in as `member.a@example.test` | "Welcome back, Morgan Member"; **My Tasks** listed the member's task |
| Use the app | Entered 0 hours, then 1.5 hours on the assigned task | "Hours must be more than 0", then "Hours were recorded." |
| Use the app | Opened `/users` as that member | Refused and sent to the home page |
| Tests: `bundle exec rspec` | Run as written | **263 examples, 0 failures** (66 s) |
| Tests: `bin/rubocop` | Run as written | 127 files inspected, no offenses |
| Tests: `bin/brakeman --no-pager` | Run as written | 0 errors, 0 security warnings |
| Tests: `bin/importmap audit` | Run as written | No vulnerable packages found |
| Locate the recovery steps | Followed the README's Documentation link to the administrator guide | Found **Update procedure**, **Simulated failed update and rollback** and **Database backup and restore** as numbered steps |

The app was set up and used from the instructions alone.

## What was unclear or wrong

| # | Gap | Effect on a new developer |
| --- | --- | --- |
| 1 | Step 3, "Configure a separate local database", gave no instruction. In fact nothing needs configuring when the computer's user can create PostgreSQL databases. | They would search for a setting that does not exist. |
| 2 | The README said to ask the team for the practice password. With `DEMO_PASSWORD` unset the seed uses a default written in `db/seeds.rb`. | After the team leaves there is nobody to ask. |
| 3 | The README (Features, release note, Deployment, CI/CD), `docs/DEPLOYMENT.md` and the administrator guide named release v23 and commit `2e4df57` as the deployed version, and told the reader to keep automatic deployment from `main` disabled. The app actually runs v27, commit `3417e8a`, and Heroku deploys `main` after CI passes. | They could believe a merge into `main` does not release, or roll back to the wrong version. |
| 4 | The README did not point from Deployment to the update and recovery steps, and listed no check that setup had worked. | Slower to find the recovery steps and to know when setup is finished. |
| 5 | The Contact table listed a developer who left during Sprint 3 as current. | Wrong person contacted. |

No command in the instructions failed.

## Corrections

All five gaps are corrected in the same commit as this record:

- [README, Installation and Setup](../../README.md#installation-and-setup): step 3 now says what the database configuration is and gives the one command that creates the PostgreSQL role; step 4 explains the practice password; a new step 5 says how to check the setup.
- [README, Deployment](../../README.md#deployment) and CI/CD: current release, automatic deployment from `main`, and a direct pointer to the update and recovery sections. Hosting cost now states the observed plans and prices.
- [Deployment guide](../DEPLOYMENT.md): current release and how a release actually happens.
- [Administrator guide, Ownership and support](../ADMIN_GUIDE.md#ownership-and-support): current release and commit.
- README Contact table.

## Second pass with the corrected instructions

Repeated on November 17, 2026 from an empty database (`bin/rails db:drop`), following the corrected steps 3 to 5.

| Corrected step | Result |
| --- | --- |
| 3. The computer's user can create databases (role exists with create-database permission) | Confirmed; nothing else to configure |
| 4. `bundle install`, `bin/rails db:prepare`, `bin/rails db:seed` | Databases created and practice data seeded, no errors |
| 5. `bin/rails server`, open `/up`, sign in as `member.a@example.test` with the practice default | `/up` 200; "Welcome back, Morgan Member"; **My Tasks** shown; 0 hours refused with "Hours must be more than 0"; 1.5 hours saved with "Hours were recorded." |
| Recovery steps | Reached from README → Deployment in one link |

**Outcome: no gaps remained on the second pass.**

## Not covered by this check

- Updating the live website was not rehearsed here. The three releases of November 16 and 17 (v25 to v27) were real updates made by merging into `main`; see [the final release verification](FINAL_RELEASE_VERIFICATION.md).
- A restore of a production backup into a separate database has not been timed and recorded since the November 2 transfer. It is listed as an open item in the turnover notebook.
- The offline restart PDF (`docs/RESTART_GUIDE.pdf`) still has blank hosting and support fields.
