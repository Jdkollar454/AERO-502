# Heroku deployment guide

## Current deployment

- App: `aero-task-hub` (formerly `sleepy-depths-47724`).
- Website: https://aero-task-hub-b5f4953964ed.herokuapp.com/
- Repository: https://github.com/joshEng1/AERO-502
- Recorded release: `v27`, commit `3417e8a0e7fe8c24b193a5a91dc2ad41421662e8`, deployed November 17, 2026. See [the final release verification](turnover/FINAL_RELEASE_VERIFICATION.md). The November 2 database transfer used `v23`, commit `2e4df57e136076beccb2eeb534b07183500aa280`.
- Heroku owner observed: Joshua's account. JD's ownership transfer remains pending.
- Database: `postgresql-convex-72612`; Postgres Essential-0, version reported as 18.4.
- `sleepy-bayou-60650` was paused as a fallback. Its deletion has not been confirmed.
- Staging app: `aero-task-hub-staging`, https://aero-task-hub-staging-ca661d8bf0bf.herokuapp.com/, with its own Essential-0 database and practice data only. It does not deploy automatically; see [the staging check](turnover/STAGING_CHECK.md) for how to update it. Check a release there before merging it into `main`.

Heroku deploys `main` automatically after its CI run passes: releases v25, v26 and v27 each followed a merge into `main` within a few minutes. A merge into `main` is therefore a release. Use the normal feature → dev → test → main flow, and confirm the setting under Heroku dashboard → app → **Deploy** after any ownership change.

## Configuration

The app uses `DATABASE_URL`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, and a private `SECRET_KEY_BASE`. `RAILS_MASTER_KEY` is needed if encrypted credentials are used; it was absent in the successful deployment. Heroku supplies the database URL. Do not copy a database URL between apps. `PASSWORD_SIGN_IN` remains enabled until the organization approves Google-only operation after testing all roles.

The exact Google authorized redirect URI for this app is:

```text
https://aero-task-hub-b5f4953964ed.herokuapp.com/auth/google_oauth2/callback
```

Edit the same OAuth client whose ID is configured on this app. After saving, start a new sign-in from the website. OAuth success still requires an approved, non-revoked People record. Do not commit credentials or paste their values into an issue, guide or screenshot.

## Future release procedure

1. Complete code review and CI on the exact intended release commit. Confirm the repository and Heroku app before pushing.
2. Record the currently deployed release and capture and download a database backup. Verify successful backup completion.
3. For schema changes, rehearse against a distinct restored test database and follow `ADMIN_GUIDE.md`. The approved migration stops when real history or memberships need reconciliation; do not fabricate attribution.
4. Merge only that reviewed commit into `main`; Heroku deploys it after CI passes. (If automatic deploys are ever turned off, push that commit to `https://git.heroku.com/aero-task-hub.git` instead.) The Procfile release phase runs `bin/rails db:migrate`; confirm with `heroku releases -a aero-task-hub` that the new release names the merged commit, and with `heroku run bin/rails db:migrate:status -a aero-task-hub` that every migration is `up`.
5. Check `/up`, Google sign-in with approved roles, denied/revoked access, the task board, the searchable Member filter, a task and its history, and the recorded hour totals.
6. Record release, commit, operator, backup and observed results in the handover record.

Do not rerun the completed database transfer during ordinary code review or deployment. Do not seed the live database. A code rollback does not restore database records or reverse this migration; recovery needs compatible code and a separately verified backup.

## Remaining operational work

Verify backup frequency, retention, storage and responsible people; complete the controlled restart and isolated recovery exercise; deliver the filled offline PDF; train JD and record feedback; finish customer UAT and ownership transfer. Retire the paused fallback only after final-app checks and retained backups are confirmed.

References: [Heroku release phase](https://devcenter.heroku.com/articles/release-phase), [PGBackups](https://devcenter.heroku.com/articles/heroku-postgres-backups), [Google redirect URI matching](https://developers.google.com/identity/protocols/oauth2/web-server).
