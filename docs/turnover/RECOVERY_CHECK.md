# Recovery rehearsal and backup setup

Run by Joshua Eng on November 17, 2026 (Texas time), with Claude Code, following **Database backup and restore** in the [administrator guide](../ADMIN_GUIDE.md#database-backup-and-restore). Production records were not changed: the production recovery manifest was identical before and after this work, and production stayed on release v27.

## Result

| Step | Result |
| --- | --- |
| Fresh production backup | `b006`, captured 2026-11-18 03:49:54 UTC, completed in 3 seconds, 57.83 KB |
| Separate target confirmed | Production database add-on `postgresql-convex-72612`; restore target `postgresql-sinuous-76934` on the staging app `aero-task-hub-staging` |
| Restore into the separate database | `heroku pg:backups:restore aero-task-hub::b006 DATABASE_URL -a aero-task-hub-staging`: restore `r001`, started 03:50:44 UTC, completed 03:50:46 UTC. The command took **12 seconds** end to end |
| Records and relationships compared | `bin/rails recovery:manifest` on both: **all 10 tables have the same row count and the same checksum; total hours 15.0 on both** (table below) |
| Restored copy works | 16 of 16 migrations `up`; the 49 role and two-account requests of [the security check](SECURITY_CHECK.md) all behaved correctly against the restored copy |
| Time from starting the restore to a verified copy | 31 seconds (restore plus manifest) |
| Staging cleaned afterwards | Database reset, migrated and reseeded with practice data: 6 practice accounts, 0 other accounts. No copy of production data remains on staging |
| Daily backups scheduled | `heroku pg:backups:schedule DATABASE_URL --at "02:00 America/Chicago" -a aero-task-hub`; `heroku pg:backups:schedules` now reports "DATABASE_URL: daily at 2:00 America/Chicago" |
| Controlled restart | On staging (release v5): `heroku ps:restart`; the dyno was back up 8 seconds after the command; the health page and sign-in page returned 200, a practice member signed in and opened an existing task |

## Manifest comparison

| Table | Rows in production | Rows in restored copy | Checksum (first 16 characters) | Result |
| --- | ---: | ---: | --- | --- |
| teams | 6 | 6 | `a1c06fce0d3e41b3…` | Same |
| subteams | 9 | 9 | `232cf23fb9585e44…` | Same |
| projects | 7 | 7 | `010e210d25080420…` | Same |
| users | 11 | 11 | `029f5863c5dc31f9…` | Same |
| memberships | 8 | 8 | `b961aae89f02b3e7…` | Same |
| tasks | 14 | 14 | `4ed929ec87920215…` | Same |
| task_assignments | 16 | 16 | `eedcc558ed2e4b32…` | Same |
| time_entries | 10 | 10 | `750934d5d5c03b4f…` | Same |
| task_status_changes | 19 | 19 | `62ffffefb4f18eb8…` | Same |
| task_dependencies | 1 | 1 | `1ef9e56bf68102c7…` | Same |

The manifest holds counts and checksums only, no record values.

## Backup method, schedule and storage

| Item | Value on November 17, 2026 |
| --- | --- |
| Method | Heroku Postgres backups (PGBackups) on the production app |
| Schedule | Automatic, daily at 2:00 a.m. Central time; plus a manual backup before each release (step 2 of the update procedure) |
| Backups on the app | `b006` (November 17, after release v27), `b005` (November 17, before v25), `b003`, `b002`, `b001` (November 2 and 3) |
| Retention | Set by Heroku for the database plan; check the list with `heroku pg:backups -a aero-task-hub` |
| Storage | Inside Heroku only. **No copy is kept in an SAE AERO location yet** |
| Responsible | Joshua Eng until the ownership transfer; then the Chief Engineer |

## Restart handout

[`docs/RESTART_GUIDE.pdf`](../RESTART_GUIDE.pdf) was rebuilt with `script/build_restart_guide.py` and its three page-1 fields are filled in: application `aero-task-hub`, the website address, and the support contact "SAE AERO Chief Engineer (JD Kollar, 2026-27). Bugs: github.com/joshEng1/AERO-502/issues". The copy offered under Help in the app is replaced when this branch is merged into `main`.

## Still open

- JD has not practiced a restore or a restart himself.
- The filled restart PDF has not been sent to JD, and page 2's delivery record is blank until he confirms receipt.
- A downloaded backup has not been stored outside Heroku.
