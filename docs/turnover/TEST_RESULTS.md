# Cumulative test results for the final release

Every automated test in the repository, run on the deployed commit `3417e8a` (Heroku release v27). The suite covers the whole product through Sprint 3 and the November 16 and 17 fixes.

| Run | Where | Result |
| --- | --- | --- |
| [CI run 44028487061, test job](https://github.com/joshEng1/AERO-502/actions/runs/44028487061/job/133854450396) | GitHub Actions, PostgreSQL 16, Chrome | **263 examples, 0 failures** |
| Fresh clone of `3417e8a`, November 17, 2026 (Joshua Eng; WSL2 Ubuntu 24.04, PostgreSQL 16.15) | `bundle exec rspec --format json` | **263 examples, 0 failures, 0 pending**; line coverage 1088 / 1088 (100%); branch coverage 399 / 399 (100%); 64 seconds |

The table below is generated from the second run's result file. Each row is one test: its description states the expected behavior, the link opens the test at the deployed commit, and the last column is the recorded outcome. About 124 of the 263 descriptions name a refusal, an invalid value or a denied request; the rest check normal use.

These are automated results. Manual checks on production are in [the security check](SECURITY_CHECK.md) and [the final release verification](FINAL_RELEASE_VERIFICATION.md). Customer UAT results are separate and are recorded in the turnover notebook.

| Quality goal | Test files | Tests | Passed |
| --- | ---: | ---: | ---: |
| Integrity: sign-in, permissions and protected data | 12 | 80 | 80 |
| Correctness: right results, including invalid input | 21 | 154 | 154 |
| Usability: tasks completed from the screen and the guide | 4 | 12 | 12 |
| Maintainability: setup, guides and tooling stay correct | 5 | 17 | 17 |
| **Total** | 42 | **263** | **263** |

Compliance (does the app do what was agreed) is shown by the same tests read story by story: see [Sprint 3 story traceability](../SPRINT3_STORIES_VERIFICATION.md) and the scope index in the turnover notebook, Appendix 7.1.

## Integrity: sign-in, permissions and protected data

### `spec/models/database_history_integrity_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Database history and prerequisite integrity enforces active and primary uniqueness, complete endings and immutable periods on direct writes | [line 13](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/database_history_integrity_spec.rb#L13) | passed |
| Database history and prerequisite integrity rejects direct circular and cross-class dependencies without changing task dates or statuses | [line 57](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/database_history_integrity_spec.rb#L57) | passed |
| Database history and prerequisite integrity enforces the creator and timestamp on the first status row | [line 48](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/database_history_integrity_spec.rb#L48) | passed |
| Database history and prerequisite integrity rejects status drift, unauthorized attribution, backdated changes and rewritten history | [line 31](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/database_history_integrity_spec.rb#L31) | passed |

### `spec/requests/administrator_handover_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Administrator handover blocks a direct request to revoke the last chief and keeps their session usable | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L22) | passed |
| Administrator handover lets a chief restore a revoked chief and then hand over access | [line 96](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L96) | passed |
| Administrator handover allows revoking an outgoing chief when another active chief remains, preserving their records | [line 63](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L63) | passed |
| Administrator handover denies direct role and access changes from officers and members | [line 111](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L111) | passed |
| Administrator handover blocks a direct request to demote the last active chief and explains the next step | [line 11](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L11) | passed |
| Administrator handover allows ordinary edits to the last chief without changing their administrator access | [line 87](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L87) | passed |
| Administrator handover enforces the same rule on ordinary model updates outside the controller | [line 124](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L124) | passed |
| Administrator handover allows an incoming chief to take over and demote the outgoing chief | [line 45](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L45) | passed |
| Administrator handover does not count a revoked Chief Engineer as a replacement administrator | [line 33](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L33) | passed |
| Administrator handover rejects removing the remaining chief after another chief has lost access | [line 78](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_handover_spec.rb#L78) | passed |

### `spec/requests/google_sign_in_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Google sign-in explains a cancelled or failed Google sign-in | [line 90](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L90) | passed |
| Google sign-in refuses accounts that are not on the list or whose email Google has not verified | [line 60](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L60) | passed |
| Google sign-in lets the Chief Engineer remove and restore a person's access from the People screen | [line 147](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L147) | passed |
| Google sign-in keeps the assigned role, class and subteam for every role across independent sessions | [line 38](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L38) | passed |
| Google sign-in clears an existing session on rejected Google sign-in and allows choosing an approved account afterwards | [line 75](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L75) | passed |
| Google sign-in gives officers and members no option to add or remove allowed people | [line 198](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L198) | passed |
| Google sign-in refuses password sign-in when it has been turned off | [line 219](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L219) | passed |
| Google sign-in offers Sign in with Google on the sign-in page | [line 24](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L24) | passed |
| Google sign-in ends a revoked session even when the next page is the public user guide | [line 185](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L185) | passed |
| Google sign-in lets the Chief Engineer add an allowed person who can then sign in on the first try | [line 100](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L100) | passed |
| Google sign-in refuses password sign-in for a person who has no password | [line 227](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L227) | passed |
| Google sign-in rejects an open task action after a chief revokes access in another session, preserving past work | [line 160](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L160) | passed |
| Google sign-in signs a removed person out at their next page load but keeps their tasks and hours | [line 129](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L129) | passed |
| Google sign-in shows errors when an added person is incomplete | [line 120](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L120) | passed |
| Google sign-in signs in an allowed email with the role and team assigned to it, ignoring letter case | [line 30](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/google_sign_in_spec.rb#L30) | passed |

### `spec/requests/sprint_one_workflow_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Sprint 1 workflow assigned member updates status and records hours | [line 35](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L35) | passed |
| Sprint 1 workflow member cannot retrieve another team's task directly | [line 27](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L27) | passed |
| Sprint 1 workflow officer cannot edit another team's task | [line 87](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L87) | passed |
| Sprint 1 workflow negative hours are rejected and previous total remains | [line 49](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L49) | passed |
| Sprint 1 workflow protected pages request sign in | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L4) | passed |
| Sprint 1 workflow team officer creates and assigns a complete task card | [line 61](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L61) | passed |
| Sprint 1 workflow valid credentials open the role-aware dashboard | [line 10](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L10) | passed |
| Sprint 1 workflow incorrect password is refused with a clear message | [line 20](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/sprint_one_workflow_spec.rb#L20) | passed |

### `spec/requests/administrator_help_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Embedded administrator instructions provides the same administrator guide and an offline PDF through Help | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_help_spec.rb#L4) | passed |
| Embedded administrator instructions requires chief access for the administrator guide and PDF, while retaining public user help | [line 17](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/administrator_help_spec.rb#L17) | passed |

### `spec/requests/access_status_delivery_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| KAN-7, KAN-9, and KAN-12 delivered access and status blocks direct reads and updates of a same-team task without an assignment | [line 90](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L90) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status shows chief engineers both teams and permits cross-team management | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L42) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status persists each assigned status transition and displays it on fresh detail, board, and dashboard requests | [line 101](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L101) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status keeps failed credentials signed out | [line 33](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L33) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status shows members only assigned tasks, including on the dashboard and board | [line 73](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L73) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status requires authentication for the dashboard, board, task detail, and status update | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L22) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status shows officers only their team and denies cross-team management | [line 54](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L54) | passed |
| KAN-7, KAN-9, and KAN-12 delivered access and status lets assigned members change status without changing other task fields or assignments | [line 125](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/access_status_delivery_spec.rb#L125) | passed |

### `spec/models/user_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| User officer manages only tasks in their team | [line 20](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/user_spec.rb#L20) | passed |
| User chief engineer may exist without a team | [line 12](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/user_spec.rb#L12) | passed |
| User normalizes email before validation | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/user_spec.rb#L4) | passed |

### `spec/requests/role_access_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Role-based access lets the Chief Engineer change a user's role, shown on their account at the next page load | [line 26](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/role_access_spec.rb#L26) | passed |
| Role-based access keeps the previous role when the change is invalid | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/role_access_spec.rb#L42) | passed |
| Role-based access gives officers and members no option to change roles | [line 51](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/role_access_spec.rb#L51) | passed |
| Role-based access blocks an officer from changing another team's task and explains why | [line 17](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/role_access_spec.rb#L17) | passed |
| Role-based access tells a person without an approved account that access is not authorized | [line 5](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/role_access_spec.rb#L5) | passed |

### `spec/models/organization_membership_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Approved organization membership integrity allows projects to exist with no tasks and share all subteams of one team | [line 27](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L27) | passed |
| Approved organization membership integrity stores one mandatory membership for members and officers and none for administrators | [line 13](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L13) | passed |
| Approved organization membership integrity validates required membership at transaction end even for direct SQL | [line 57](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L57) | passed |
| Approved organization membership integrity rejects invalid roles and incompatible application-level ownership changes | [line 77](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L77) | passed |
| Approved organization membership integrity rechecks eligibility across every source of team ownership on direct writes | [line 69](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L69) | passed |
| Approved organization membership integrity transfers membership inside the class while keeping task IDs and hours | [line 36](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L36) | passed |
| Approved organization membership integrity requires resolving active assignments before moving between teams or promoting to administrator | [line 46](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/organization_membership_spec.rb#L46) | passed |

### `spec/requests/task_history_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task history records the initial status and creator when a task is created in any column | [line 24](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L24) | passed |
| Task history does not add periods or status changes for unchanged fields | [line 33](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L33) | passed |
| Task history prevents editing or deleting status history and rewriting assignment periods in SQL | [line 74](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L74) | passed |
| Task history ends assignment periods with the remover and starts a new period on reassignment | [line 11](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L11) | passed |
| Task history keeps all history and logged hours when a leader tries to delete the task | [line 66](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L66) | passed |
| Task history combines assignment and status history newest first with named actors | [line 40](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L40) | passed |
| Task history shows the initial status to leaders and hides the history from members | [line 57](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_history_spec.rb#L57) | passed |

### `spec/models/concurrent_ownership_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Concurrent ownership transfers serializes direct writes and rejects a transfer invalidated by the earlier commit | [line 9](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/concurrent_ownership_spec.rb#L9) | passed |

### `spec/requests/time_entry_management_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Recording actual hours confirms a saved entry and lists it on the task with its date, member and hours | [line 13](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L13) | passed |
| Recording actual hours explains each limit when hours are zero or less, over 24, or not a number | [line 23](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L23) | passed |
| Recording actual hours shows edit and delete controls only on the member's own entries | [line 117](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L117) | passed |
| Recording actual hours lets the website, not the browser, answer a mistake and keeps what was typed | [line 46](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L46) | passed |
| Recording actual hours lets a member correct their own entry and keeps the 24-hour limit on edits | [line 77](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L77) | passed |
| Recording actual hours asks for the date when it is left blank | [line 38](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L38) | passed |
| Recording actual hours refuses to let anyone change or remove another member's entry | [line 101](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L101) | passed |
| Recording actual hours shows the total of all assignees' hours, the estimate and the difference | [line 126](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L126) | passed |
| Recording actual hours lets a member remove their own entry and updates the task total | [line 93](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L93) | passed |
| Recording actual hours limits a member's total for one worked date to 24 hours across all tasks | [line 64](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/time_entry_management_spec.rb#L64) | passed |

## Correctness: right results, including invalid input

### `spec/requests/task_project_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task projects moves the task's subteam and team when a leader changes its project | [line 19](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_project_spec.rb#L19) | passed |
| Task projects refuses an officer's task in another team's project | [line 39](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_project_spec.rb#L39) | passed |
| Task projects lists projects as Team · Subteam · Project and limits officers to their own team | [line 28](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_project_spec.rb#L28) | passed |
| Task projects derives the team from the project and ignores submitted ownership fields | [line 9](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_project_spec.rb#L9) | passed |
| Task projects requires a project | [line 47](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_project_spec.rb#L47) | passed |

### `spec/requests/status_updates_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task status updates records status changes made by a leader on the edit form | [line 37](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L37) | passed |
| Task status updates gives unassigned members no way to change the status and records nothing | [line 66](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L66) | passed |
| Task status updates records the actor, old status, new status and time of each change | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L22) | passed |
| Task status updates does not record an event when the status is unchanged or the change fails | [line 46](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L46) | passed |
| Task status updates moves an assigned member's task to the chosen column and keeps it there after refreshing | [line 6](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L6) | passed |
| Task status updates keeps every task in exactly one of the three statuses | [line 58](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L58) | passed |
| Task status updates rolls back the status change when the event cannot be saved | [line 76](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/status_updates_spec.rb#L76) | passed |

### `spec/models/recovery_manifest_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| RecoveryManifest compares all ten tables without exposing account values and detects changed data | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/recovery_manifest_spec.rb#L4) | passed |

### `spec/requests/csv_reports_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Filtered CSV reports downloads exactly the filtered board tasks with complete columns and matching totals | [line 32](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L32) | passed |
| Filtered CSV reports exports the timeline's task rows and refreshes changed dates | [line 58](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L58) | passed |
| Filtered CSV reports handles several selected teams but never exports another class to its officer | [line 101](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L101) | passed |
| Filtered CSV reports combines member, team, subteam, project, search and task-date filters and counts shared estimates once | [line 47](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L47) | passed |
| Filtered CSV reports preserves quotes, commas, newlines and accents while neutralizing spreadsheet formulas | [line 125](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L125) | passed |
| Filtered CSV reports keeps zero members visible on an empty filtered board and returns header-only task downloads | [line 90](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L90) | passed |
| Filtered CSV reports uses worked dates inclusively and applies member filters to both member and project hours | [line 79](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L79) | passed |
| Filtered CSV reports hides downloads from members and denies every direct CSV endpoint | [line 113](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L113) | passed |
| Filtered CSV reports shares invalid-hour-date fallback and supports reports without a project selection | [line 137](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L137) | passed |
| Filtered CSV reports includes zero-hour members without assignments and matches on-screen member totals | [line 68](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/csv_reports_spec.rb#L68) | passed |

### `spec/helpers/tasks_helper_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| TasksHelper#external_link links http and https addresses in a new tab | [line 5](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/helpers/tasks_helper_spec.rb#L5) | passed |
| TasksHelper#external_link shows any other address as plain text | [line 10](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/helpers/tasks_helper_spec.rb#L10) | passed |
| TasksHelper#estimate_label describes variance as over, under or on the estimate | [line 20](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/helpers/tasks_helper_spec.rb#L20) | passed |
| TasksHelper#estimate_label formats saved estimates in hours, including zero | [line 26](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/helpers/tasks_helper_spec.rb#L26) | passed |
| TasksHelper#estimate_label labels a missing legacy estimate as Not estimated | [line 16](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/helpers/tasks_helper_spec.rb#L16) | passed |

### `spec/models/legacy_migration_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Approved Sprint 3 migration reports inconsistent status chains and active assignment rows | [line 86](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L86) | passed |
| Approved Sprint 3 migration converts real history into periods and ordered statuses without losing IDs, actors, hours or reference links | [line 55](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L55) | passed |
| Approved Sprint 3 migration stops before changing tables when an actor is missing, rather than inventing attribution | [line 71](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L71) | passed |
| Approved Sprint 3 migration reports incomplete memberships and unknown history instead of silently discarding them | [line 79](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L79) | passed |
| Approved Sprint 3 migration provides a read-only preflight command that fails when reconciliation is needed | [line 130](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L130) | passed |
| Approved Sprint 3 migration requires a reliable initial status and agreement with the task's final status | [line 104](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L104) | passed |
| Approved Sprint 3 migration refuses lossy rollback instructions | [line 93](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L93) | passed |
| Approved Sprint 3 migration preserves fully ended assignments and rejects duplicate period start times | [line 120](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L120) | passed |
| Approved Sprint 3 migration reports missing assignees, overlapping periods and endings without beginnings | [line 112](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L112) | passed |
| Approved Sprint 3 migration reports administrator memberships and conflicting parent classes | [line 97](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/legacy_migration_spec.rb#L97) | passed |

### `spec/models/task_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task reports actual totals and variance | [line 34](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L34) | passed |
| Task accessible scope follows role and assignment | [line 27](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L27) | passed |
| Task calculates member hours consistently with preloaded entries | [line 12](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L12) | passed |
| Task rejects a negative estimate without changing the saved value | [line 18](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L18) | passed |
| Task lists saved links in order and keeps them when other fields change | [line 56](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L56) | passed |
| Task defaults the start date to today and requires a due date on or after it | [line 64](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L64) | passed |
| Task derives its team from its project and subteams from active assignees | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L4) | passed |
| Task accepts only full http and https web addresses as reference links | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_spec.rb#L42) | passed |

### `spec/models/time_entry_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| TimeEntry requires positive hours | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/time_entry_spec.rb#L4) | passed |
| TimeEntry rejects hours from an unassigned member | [line 12](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/time_entry_spec.rb#L12) | passed |

### `spec/requests/task_management_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task management lets chief engineers open cross-team forms and preserve the initial history of a new task | [line 82](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L82) | passed |
| Task management shows login, redirects signed-in users, and revokes access after logout | [line 8](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L8) | passed |
| Task management rolls back edits when an assignee belongs to another team | [line 72](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L72) | passed |
| Task management shows only assigned work on the member board and detail page | [line 20](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L20) | passed |
| Task management prevents members from creating tasks, updating unassigned work, or logging others' hours | [line 30](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L30) | passed |
| Task management renders a validation error for a blank member status | [line 43](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L43) | passed |
| Task management lets officers open forms and update their team's task | [line 50](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L50) | passed |
| Task management rejects invalid task creation and updates without persisting them | [line 61](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_management_spec.rb#L61) | passed |

### `spec/requests/effort_delivery_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Effort and dashboard delivery shows an assigned shared task once on the member's board and keeps hours for leaders | [line 96](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L96) | passed |
| Effort and dashboard delivery accepts ordinary positive decimal entries with no browser limit in the way | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L4) | passed |
| Effort and dashboard delivery shows 4 plus 3 hours once on the detail page and the chief's board summary | [line 69](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L69) | passed |
| Effort and dashboard delivery records hours, date, and note for the signed-in assignee despite a forged user id | [line 19](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L19) | passed |
| Effort and dashboard delivery explains an empty assignment list on the member board | [line 108](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L108) | passed |
| Effort and dashboard delivery refuses zero, negative, and undated hours, and refuses an unassigned member | [line 43](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/effort_delivery_spec.rb#L43) | passed |

### `spec/requests/planned_vs_actual_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Planned vs. actual effort states on the task how far actual hours are from the estimate | [line 16](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/planned_vs_actual_spec.rb#L16) | passed |
| Planned vs. actual effort accepts a zero estimate and rejects a negative one (reconciled with KAN-8 and KAN-10) | [line 5](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/planned_vs_actual_spec.rb#L5) | passed |
| Planned vs. actual effort shows each member's estimated hours, actual hours and difference in the leader summary | [line 25](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/planned_vs_actual_spec.rb#L25) | passed |

### `spec/requests/shared_projects_and_rosters_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Shared projects and subteam rosters keeps an unassigned task on its project board but off all subteam boards | [line 36](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L36) | passed |
| Shared projects and subteam rosters denies direct roster changes and reads to members and officers of another class | [line 111](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L111) | passed |
| Shared projects and subteam rosters refuses removal without a destination and rejects foreign, unknown and revoked people | [line 95](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L95) | passed |
| Shared projects and subteam rosters shows one shared task once on each assignee's subteam board and once in the combined view | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L22) | passed |
| Shared projects and subteam rosters creates a team-owned project without selecting participating subteams | [line 11](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L11) | passed |
| Shared projects and subteam rosters scopes roster work and hours to projects and dates without hiding zero-work members | [line 123](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L123) | passed |
| Shared projects and subteam rosters shows every roster person including officers and zero-work members | [line 69](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L69) | passed |
| Shared projects and subteam rosters denies a foreign parent and duplicate project name but allows an empty project | [line 47](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L47) | passed |
| Shared projects and subteam rosters atomically transfers a person and updates board membership while preserving task IDs and hours | [line 80](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L80) | passed |
| Shared projects and subteam rosters keeps a project's parent fixed in the form and preserves the task when viewed | [line 59](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L59) | passed |
| Shared projects and subteam rosters preserves membership when an existing invalid user cannot be transferred | [line 132](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/shared_projects_and_rosters_spec.rb#L132) | passed |

### `spec/requests/board_summary_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Board summary and hours rejects a reversed or unreadable date range and shows all hours instead | [line 94](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L94) | passed |
| Board summary and hours keeps the hours date range when filters change, and the filters when dates change | [line 114](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L114) | passed |
| Board summary and hours shows an officer only their own team | [line 125](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L125) | passed |
| Board summary and hours shows members no hours summary and no leader summary | [line 133](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L133) | passed |
| Board summary and hours removes Progress from the menu and sends old Progress and Dashboard links to the board's hours | [line 159](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L159) | passed |
| Board summary and hours AC2: labels unfinished tasks past their due date as Overdue automatically | [line 41](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L41) | passed |
| Board summary and hours AC4: shows the member hour summary under the board as a table and a matching chart | [line 68](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L68) | passed |
| Board summary and hours narrows the board and hours to a selected project | [line 104](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L104) | passed |
| Board summary and hours includes both endpoint dates and labels shared estimates without double counting them | [line 81](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L81) | passed |
| Board summary and hours AC5: keeps all three columns, including Completed, visible | [line 53](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L53) | passed |
| Board summary and hours AC1/AC3: shows each column's count for the current filters | [line 32](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L32) | passed |
| Board summary and hours sums up overdue work and hours for leaders above the board | [line 60](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L60) | passed |
| Board summary and hours shows the hours summary on the board view only, not My Tasks | [line 141](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L141) | passed |
| Board summary and hours shows new values after a status or hours change when the leader refreshes | [line 148](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_summary_spec.rb#L148) | passed |

### `spec/requests/task_card_creation_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task card creation saves the chosen initial status, keeps reference links in instructions, and shows every detail | [line 72](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L72) | passed |
| Task card creation asks for a full web address when a reference link is invalid | [line 61](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L61) | passed |
| Task card creation defaults the start date to today and marks only the required fields as required | [line 21](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L21) | passed |
| Task card creation rejects a due date earlier than the start date with a message next to the due date | [line 50](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L50) | passed |
| Task card creation accepts optional fields left blank and a due date equal to the start date | [line 95](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L95) | passed |
| Task card creation lets the Chief Engineer create a task card for any team | [line 106](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L106) | passed |
| Task card creation replaces the saved links when a leader edits them | [line 117](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L117) | passed |
| Task card creation hides the Create Task option from members and refuses direct creation | [line 124](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L124) | passed |
| Task card creation shows an error next to each missing required field and saves nothing | [line 35](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_creation_spec.rb#L35) | passed |

### `spec/models/sprint_three_boundaries_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Sprint 3 assignment and ownership boundaries retains historical contributors in a task summary even after unassignment | [line 64](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/sprint_three_boundaries_spec.rb#L64) | passed |
| Sprint 3 assignment and ownership boundaries allows clearing a primary contact without ending the assignment | [line 21](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/sprint_three_boundaries_spec.rb#L21) | passed |
| Sprint 3 assignment and ownership boundaries rejects missing and cross-team prerequisites and inconsistent class hints | [line 52](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/sprint_three_boundaries_spec.rb#L52) | passed |
| Sprint 3 assignment and ownership boundaries permits empty ownership moves while rejecting unresolved assignments and dependencies | [line 30](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/sprint_three_boundaries_spec.rb#L30) | passed |
| Sprint 3 assignment and ownership boundaries rejects ineligible assignees and partially ended or primary ended periods | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/sprint_three_boundaries_spec.rb#L4) | passed |

### `spec/requests/task_search_filter_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task search and filters keeps the chosen filters on My Tasks and the timeline, which return the same tasks | [line 52](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L52) | passed |
| Task search and filters submits additional projects and teams from the checkbox dropdowns | [line 108](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L108) | passed |
| Task search and filters never exposes another team's restricted tasks through search | [line 44](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L44) | passed |
| Task search and filters opens a member's board on their own team and subteam, which they can clear | [line 70](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L70) | passed |
| Task search and filters labels every filter control | [line 86](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L86) | passed |
| Task search and filters filters by team and subteam and combines filters with search | [line 25](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L25) | passed |
| Task search and filters searches permitted task titles and descriptions | [line 13](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L13) | passed |
| Task search and filters restores every permitted task when the filters are cleared | [line 36](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_search_filter_spec.rb#L36) | passed |

### `spec/requests/timeline_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Task timeline draws each task as a bar from its start date to its due date, grouped by team and subteam | [line 11](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L11) | passed |
| Task timeline lists the same dates in a text table for every task shown | [line 58](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L58) | passed |
| Task timeline scrolls sideways through one continuous window instead of paging through weeks | [line 27](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L27) | passed |
| Task timeline ignores the old paging parameters | [line 96](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L96) | passed |
| Task timeline explains an empty timeline | [line 132](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L132) | passed |
| Task timeline shows a day axis with week headings and a line for today | [line 38](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L38) | passed |
| Task timeline shows an officer only their own team and hides the timeline from members | [line 118](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L118) | passed |
| Task timeline reflects changed dates when the leader refreshes | [line 74](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L74) | passed |
| Task timeline stretches the window to cover every task's dates | [line 82](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L82) | passed |
| Task timeline follows the team and subteam filters | [line 66](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L66) | passed |
| Task timeline highlights unfinished tasks past their due date as overdue, in the chart and the text list | [line 48](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L48) | passed |
| Task timeline limits far-off dates and marks tasks beyond the limits as earlier or later | [line 104](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/timeline_spec.rb#L104) | passed |

### `spec/models/task_status_change_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| TaskStatusChange requires a real actor and status instead of a placeholder history record | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_status_change_spec.rb#L4) | passed |
| TaskStatusChange retains immutable status history | [line 10](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/models/task_status_change_spec.rb#L10) | passed |

### `spec/requests/board_creation_and_dependencies_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Board creation and prerequisites denies member dependency edits even though the member can update task status | [line 117](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L117) | passed |
| Board creation and prerequisites offers the project board after an unassigned save and does not invent subteam ownership | [line 55](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L55) | passed |
| Board creation and prerequisites rejects self-links, circular chains, foreign teams and unknown tasks without partial edits | [line 101](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L101) | passed |
| Board creation and prerequisites retains revoked assignees on an unrelated edit but prevents new revoked assignments | [line 157](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L157) | passed |
| Board creation and prerequisites keeps empty columns and starts creation in each chosen column with the project prefilled | [line 13](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L13) | passed |
| Board creation and prerequisites asks for a project when several are selected and retains entered values and filters on errors and cancel | [line 35](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L35) | passed |
| Board creation and prerequisites excludes archived projects from new task choices even when an old filter names one | [line 140](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L140) | passed |
| Board creation and prerequisites does not reveal unassigned prerequisite task details to a member | [line 129](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L129) | passed |
| Board creation and prerequisites shows outstanding prerequisites with their owners and clears only the derived blocked state | [line 82](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L82) | passed |
| Board creation and prerequisites keeps one optional primary contact among active assignees and clears it on removal | [line 70](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/board_creation_and_dependencies_spec.rb#L70) | passed |

### `spec/requests/estimate_display_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Estimated hours display persists a decimal estimate entered by the team officer after reopening the task | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L22) | passed |
| Estimated hours display shows a saved zero estimate as 0 hours | [line 14](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L14) | passed |
| Estimated hours display does not let the assigned member change the estimate | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L42) | passed |
| Estimated hours display does not let an officer change another team's estimate | [line 49](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L49) | passed |
| Estimated hours display shows the saved estimate with an Estimated hours label to the assigned member | [line 5](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L5) | passed |
| Estimated hours display rejects nonnumeric and negative estimates and keeps the last valid value | [line 30](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/estimate_display_spec.rb#L30) | passed |

### `spec/requests/organization_management_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Organization management B1.9: lets a Team A officer manage only Team A subteams and projects, including direct requests | [line 106](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L106) | passed |
| Organization management B1.5/B1.8: keeps a new subteam under its team after refreshing and offers its projects in the task form | [line 61](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L61) | passed |
| Organization management B1.7: renames and archives records; archived ones leave everyday lists but their tasks and hours stay viewable | [line 75](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L75) | passed |
| Organization management shows officers only their own team, offers only their subteams as parents, and gives members nothing | [line 155](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L155) | passed |
| Organization management lets the Chief Engineer place a person in a subteam of their team | [line 186](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L186) | passed |
| Organization management B1.4/B1.8: refuses a missing name or parent, identifies the field and creates nothing | [line 47](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L47) | passed |
| Organization management keeps a record's parent fixed after creation so its tasks stay consistent | [line 146](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L146) | passed |
| Organization management groups each record's Rename and Archive actions in a Manage menu and shows counts per team | [line 131](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L131) | passed |
| Organization management seeds the SAE AERO classes, their subteams and starter projects | [line 197](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L197) | passed |
| Organization management B1.3: lets an officer add a second project to their subteam without duplicating it | [line 40](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L40) | passed |
| Organization management opens the create, rename and record pages for each kind of record | [line 173](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L173) | passed |
| Organization management B1.1/B1.2: builds Team > Subteam > Project and shows the saved parents when reopened | [line 21](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/organization_management_spec.rb#L21) | passed |

## Usability: tasks completed from the screen and the guide

### `spec/system/member_selector_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Meeting task assignment browses 80 members, searches with the keyboard, preserves selections and saves from a board column | [line 80](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/system/member_selector_spec.rb#L80) | passed |

### `spec/requests/user_guide_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| User guide refuses a guide to a role that has no tab for it, and falls back to the member guide for an unknown name | [line 97](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L97) | passed |
| User guide keeps each role's steps in its own guide | [line 63](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L63) | passed |
| User guide opens without signing in so people who cannot sign in can read what to do | [line 14](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L14) | passed |
| User guide D2.6: explains every message the website shows, with a next step, in the guide for the role that can meet it | [line 28](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L28) | passed |
| User guide shows each role only the tabs for its own guides, marking the open one | [line 75](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L75) | passed |
| User guide D2.3: contains no passwords and renders as safe HTML | [line 118](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L118) | passed |
| User guide D2.7: is linked from the header and from the sign-in page | [line 5](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/user_guide_spec.rb#L5) | passed |

### `spec/requests/task_card_delivery_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Delivered task card stories assigns multiple members once each and removes a member when edited | [line 89](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_delivery_spec.rb#L89) | passed |
| Delivered task card stories saves an edited estimate and rejects negative and nonnumeric estimates | [line 64](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_delivery_spec.rb#L64) | passed |
| Delivered task card stories creates a complete task card and renders its saved fields on detail and edit pages | [line 22](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/task_card_delivery_spec.rb#L22) | passed |

### `spec/system/member_filter_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Searchable member filter searches 80 members and keeps the selected ID and other filters across board and timeline | [line 17](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/system/member_filter_spec.rb#L17) | passed |

## Maintainability: setup, guides and tooling stay correct

### `spec/requests/health_delivery_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| KAN-14 deployment health serves the Rails health endpoint without signing in | [line 4](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/requests/health_delivery_spec.rb#L4) | passed |

### `spec/docs/admin_guide_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Administration guide D4.6: lists ownership, cost, support, backup location and configuration names without secret values | [line 24](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/docs/admin_guide_spec.rb#L24) | passed |
| Administration guide D4.8: separates first-time seed setup from the Teams management screen | [line 19](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/docs/admin_guide_spec.rb#L19) | passed |
| Administration guide D4.7: explains approving a person, changing their role and removing access on the People screen | [line 12](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/docs/admin_guide_spec.rb#L12) | passed |
| Administration guide D4.4/D4.5: gives update, rollback, backup and restore as numbered steps and says what a restore loses | [line 35](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/docs/admin_guide_spec.rb#L35) | passed |

### `spec/lib/chrome_detached_node_retry_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| ChromeDetachedNodeRetry leaves ordinary stale-element recovery working | [line 57](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L57) | passed |
| ChromeDetachedNodeRetry reloads and retries a detached node within the normal wait | [line 11](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L11) | passed |
| ChromeDetachedNodeRetry does not retry application errors with the same text | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L42) | passed |
| ChromeDetachedNodeRetry does not retry unrelated Selenium errors | [line 34](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L34) | passed |
| ChromeDetachedNodeRetry honors a caller that excludes stale-element retries | [line 50](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L50) | passed |
| ChromeDetachedNodeRetry still raises the original error when the wait expires | [line 26](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/lib/chrome_detached_node_retry_spec.rb#L26) | passed |

### `spec/tasks/users_rake_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| users:grant_chief_engineer promotes an existing person and restores revoked access without renaming them | [line 27](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/users_rake_spec.rb#L27) | passed |
| users:grant_chief_engineer refuses to run without any emails | [line 38](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/users_rake_spec.rb#L38) | passed |
| users:grant_chief_engineer adds new Google-only Chief Engineers who can sign in without a password | [line 17](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/users_rake_spec.rb#L17) | passed |
| users:grant_chief_engineer reports invalid emails and fails | [line 42](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/users_rake_spec.rb#L42) | passed |

### `spec/tasks/recovery_rake_spec.rb`

| Expected behavior (test description) | Test | Outcome |
| --- | --- | --- |
| Read-only deployment verification commands identifies an already migrated schema without attempting legacy conversion | [line 16](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/recovery_rake_spec.rb#L16) | passed |
| Read-only deployment verification commands captures a consistent recovery manifest without changing records | [line 9](https://github.com/joshEng1/AERO-502/blob/3417e8a0e7fe8c24b193a5a91dc2ad41421662e8/spec/tasks/recovery_rake_spec.rb#L9) | passed |
