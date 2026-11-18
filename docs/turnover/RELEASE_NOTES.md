# Release notes

## Final release: Heroku v27, November 17, 2026

- **App:** AERO Task Hub, https://aero-task-hub-b5f4953964ed.herokuapp.com/
- **Commit:** [`3417e8a`](https://github.com/joshEng1/AERO-502/commit/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8) on `main`
- **Checks:** [CI run 44028487061](https://github.com/joshEng1/AERO-502/actions/runs/44028487061), 263 tests, 0 failures; style and both security scans passed
- **Verification:** [final release verification](FINAL_RELEASE_VERIFICATION.md), [cumulative test results](TEST_RESULTS.md), [security check](SECURITY_CHECK.md)
- **Database:** no schema change since v23; 16 migrations applied

### Changed since v24 (November 2)

| Change | Pull request | Release |
| --- | --- | --- |
| A refused hours entry now shows the website's own message instead of a browser pop-up: "Hours must be more than 0", "Hours must be a number, such as 1 or 2.5", "The most for one day is 24 hours", "Date worked can't be blank". What the person typed stays in the form. | [#48](https://github.com/joshEng1/AERO-502/pull/48) | v25 |
| The Additional teams and Additional projects filters are checkbox dropdowns. | [#48](https://github.com/joshEng1/AERO-502/pull/48) | v25 |
| An empty board or My Tasks page shows one message that says why it is empty. | [#48](https://github.com/joshEng1/AERO-502/pull/48) | v25 |
| **Help** has one tab per role. Everyone sees the Member guide; officers also see the Officer guide; the Chief Engineer also sees the Chief Engineer and Administrator guides. A role without a tab is refused if it types the address. | [#49](https://github.com/joshEng1/AERO-502/pull/49) | v26 |
| The Member guide starts at its first step, Sign in. | [#50](https://github.com/joshEng1/AERO-502/pull/50) | v27 |

### What the release contains

| Sprint | Delivered | Jira stories |
| --- | --- | --- |
| 1 | Sign-in with roles; task cards with instructions, dates and estimates; assignments; My Tasks; status updates; dated hours with planned against actual; deployment; user and administrator guides; training checklist | KAN-6 to KAN-18, KAN-24 |
| 2 | Classes, subteams and projects with archiving; task history; search and filters; board summary with overdue labels and hours; protection of the last active Chief Engineer | KAN-19, KAN-20, KAN-21, KAN-29, KAN-26 |
| 3 | Google sign-in for approved people only; team-owned projects shared by subteams; subteam rosters; creating tasks from filtered and empty boards; searchable member picker for 80 members; task prerequisites and blockers; CSV downloads; scrolling timeline; administrator help inside the app; restart PDF; backup and recovery instructions; normalized database (Revision 6) | KAN-22, KAN-23, KAN-25, KAN-34 to KAN-38, KAN-40 to KAN-42 |

### Known issues in this release

| Issue | Effect | Workaround |
| --- | --- | --- |
| A Chief Engineer cannot be assigned to a task (customer request C01). | A Chief Engineer who does hands-on work cannot log hours against a task. | None agreed. An assigned member records the hours for that work. |
| People whose access was removed stay in the People list (customer request C02). | The list grows each season. | None needed for security: a removed person cannot sign in, and the list marks them "Access removed". |
| A task cannot be deleted. | A task created by mistake stays. | Mark it Completed, or archive its project. |
| The timeline shows no scrollbar when every task fits in about eight weeks (found November 6; unchanged since). | Sideways scrolling cannot be seen on a short schedule. | None needed; it appears when the schedule is longer. |
| The first visit after the site has been idle takes several seconds. | Slow first page on the Eco hosting plan. | Wait; later pages are fast. |
| Practice accounts (`@example.test`) and password sign-in are still enabled on the live website for customer testing. | Anyone who has the practice password can use a practice account, including the practice Chief Engineer. | After UAT, remove access for the practice accounts under **People** and set `PASSWORD_SIGN_IN` to `off`. |
| The restart PDF offered under Help has blank hosting and support fields until the documentation branch is merged. | The downloaded copy is incomplete. | Use the filled copy in the repository, or the administrator guide under Help. |

### Not included

Card-based attendance, full parity with a commercial project tool, bulk spreadsheet import, automatic scheduling and critical paths, picture attachments, comments and notifications. These were excluded from scope or left as optional backlog.

## Earlier releases

| Release | Date (Texas time) | Commit | Contents |
| --- | --- | --- | --- |
| v24 | November 2, 2026 | `cbdf7a0` | Sprint 3 release: searchable member picker and Member filter, scrolling timeline, reconciled `main` |
| v23 | November 2, 2026 | `2e4df57` | Approved Sprint 3 implementation and the database migration to Revision 6; see [the handover record](../SPRINT3_HANDOVER.md) |
| v18 | October 15, 2026 | `f6345ee` | Sprint 2 release: organization management, history, search, board summary, Chief Engineer safeguard |
