# Release notes

## Final release: Heroku v33, November 23, 2026

- **App:** AERO Task Hub, https://aero-task-hub-b5f4953964ed.herokuapp.com/
- **Commit:** [`b236771`](https://github.com/joshEng1/AERO-502/commit/b236771a5fb0ee9ecd953d9140ca025ec07236d5) on `main`
- **Checks:** [CI run 45335416273](https://github.com/joshEng1/AERO-502/actions/runs/45335416273), 297 tests, 0 failures; style and both security scans passed
- **Verification:** [final release verification](FINAL_RELEASE_VERIFICATION.md), [cumulative test results](TEST_RESULTS.md), [security check](SECURITY_CHECK.md)
- **Database:** four migrations since v27, 20 applied in total; `users` gained `permanently_removed_at`
- **Runtime:** Ruby 4.0.10, Rails 8.1.4.1

The documentation commit that adds these records and the corrected guides to `main` follows this release and changes no application code.

### Changed since v27 (November 17)

| Change | Source | Release |
| --- | --- | --- |
| **A Chief Engineer can be assigned to a task**, including by assigning themselves, without a subteam membership. They see the work under My Tasks and can log hours on it. Customer request C01. | [Pull request #51](https://github.com/joshEng1/AERO-502/pull/51) | v28 |
| **Former members can be removed from the People list.** People has two lists, Current people and Removed people. **Remove person** blocks sign-in and moves the person to Removed people; **Restore person** brings the same account back. Customer request C02. | [Pull request #51](https://github.com/joshEng1/AERO-502/pull/51) | v28 |
| **Permanently remove** clears a removed person from both lists after the Chief Engineer types their full name. Their email and sign-in details are erased; their name stays on their assignments, hours and history. It cannot be undone. | [Pull request #51](https://github.com/joshEng1/AERO-502/pull/51) | v29 |
| The People list has search and shows 25 people per page. | [Pull request #51](https://github.com/joshEng1/AERO-502/pull/51) | v28 |
| A **Dark mode** switch in the page header; the choice is remembered in the browser. | [Pull request #51](https://github.com/joshEng1/AERO-502/pull/51) | v28 |
| Ruby 4.0.6 to 4.0.10, Rails 8.1.4 to 8.1.4.1 and Brakeman 8.1.0 to 8.1.1, after the security scan reported a critical vulnerability in Ruby 4.0.6. | [Commit `1d4a71a`](https://github.com/joshEng1/AERO-502/commit/1d4a71a4a18bb01cde55c60848938cbee6308b65) | v30 |
| Removing a person is recorded in the approved `access_revoked_at` column. The separate `removed_at` column and the **Restrict access** button are gone: blocking someone's sign-in always moves them to Removed people. | [Pull request #58](https://github.com/joshEng1/AERO-502/pull/58) | v33 |

Releases v28 and v29 were deployed from the feature branch on November 19 before a pull request or CI. Release v30 is the same code after pull request #51 and a passing CI run; v31 and v32 added records and guides only; see [the final release verification](FINAL_RELEASE_VERIFICATION.md).

### What the release contains

| Sprint | Delivered | Jira stories |
| --- | --- | --- |
| 1 | Sign-in with roles; task cards with instructions, dates and estimates; assignments; My Tasks; status updates; dated hours with planned against actual; deployment; user and administrator guides; training checklist | KAN-6 to KAN-18, KAN-24 |
| 2 | Classes, subteams and projects with archiving; task history; search and filters; board summary with overdue labels and hours; protection of the last active Chief Engineer | KAN-19, KAN-20, KAN-21, KAN-29, KAN-26 |
| 3 | Google sign-in for approved people only; team-owned projects shared by subteams; subteam rosters; creating tasks from filtered and empty boards; searchable member picker for 80 members; task prerequisites and blockers; CSV downloads; scrolling timeline; administrator help inside the app; restart PDF; backup and recovery instructions; normalized database (Revision 6) | KAN-22, KAN-23, KAN-25, KAN-34 to KAN-38, KAN-40 to KAN-42 |
| After Sprint 3 | The customer's two final requests: a Chief Engineer can be assigned to a task; former members can be removed from the People list, restored, or permanently removed while their hours and history are kept. Also a dark mode switch, and search and pages on the People list | Customer requests C01 and C02 (November 2026) |

### Known issues in this release

| Issue | Effect | Workaround |
| --- | --- | --- |
| A task cannot be deleted. | A task created by mistake stays. | Mark it Completed, or archive its project. |
| The timeline shows no scrollbar when every task fits in about eight weeks (found November 6; unchanged since). | Sideways scrolling cannot be seen on a short schedule. | None needed; it appears when the schedule is longer. |
| On the timeline, class headings scroll out of view when the chart is scrolled sideways; task names stay in place (found November 18). | On a long schedule the class name is not visible at later dates. | Read the class from the subteam label, or scroll back. |
| The first visit after the site has been idle takes several seconds. | Slow first page on the Eco hosting plan. | Wait; later pages are fast. |
| Practice accounts (`@example.test`) and password sign-in are still enabled on the live website for customer testing. | Anyone who has the practice password can use a practice account, including the practice Chief Engineer. | At the ownership transfer, remove the practice accounts under **People** and set `PASSWORD_SIGN_IN` to `off`. |
| Permanently removing a person cannot be undone. | Their email and sign-in details are erased; a returning member needs a new account. | Use **Remove person** and **Restore person** unless the person will not return. |

Resolved since v27: a Chief Engineer can now be assigned to a task (C01), and former members can be removed from the People list (C02).

### Not included

Card-based attendance, full parity with a commercial project tool, bulk spreadsheet import, automatic scheduling and critical paths, picture attachments, comments and notifications. These were excluded from scope or left as optional backlog.

## Earlier releases

| Release | Date (Texas time) | Commit | Contents |
| --- | --- | --- | --- |
| v27 | November 17, 2026 | `3417e8a` | Messages for refused hours, checkbox filters, one Help tab per role, Member guide starting at Sign in (pull requests #48 to #50) |
| v24 | November 2, 2026 | `cbdf7a0` | Sprint 3 release: searchable member picker and Member filter, scrolling timeline, reconciled `main` |
| v23 | November 2, 2026 | `2e4df57` | Approved Sprint 3 implementation and the database migration to Revision 6; see [the handover record](../SPRINT3_HANDOVER.md) |
| v18 | October 15, 2026 | `f6345ee` | Sprint 2 release: organization management, history, search, board summary, Chief Engineer safeguard |
