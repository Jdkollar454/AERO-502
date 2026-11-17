# AERO Task Hub officer guide

This guide is for class officers and the Chief Engineer. Open it from **Help**, then the **Officer guide** tab; members do not see that tab. Everything in the **Member guide** applies to you too, so read that first for signing in, finding work, updating status and recording your own hours. This guide adds only what leaders can do.

Every step is written out in words; nothing depends on a screenshot or on color. Every link, field and button can be reached with Tab and used with Enter or Space.

## Extra filters for leaders

On the board, My Tasks and the Timeline, leaders have more filters than members. Choose a **Member** and **Task dates from/to**; the date filter includes tasks overlapping that period. Use **Additional teams** or **Additional projects** to include more selections (open the dropdown and tick as many as you need). Select **Apply** to update the results.

**Member** is searchable: click or Tab into it to browse, then type part of a name (capitalization does not matter). Click a result or use the arrow keys and Enter to choose it, then select **Apply**. The list scrolls without expanding the page. Choose **All members**, erase the field, or use **Clear member filter** to remove only that filter; select **Apply** to update the results. Escape cancels an unselected search and keeps the previous member.

## Create or edit a task

1. Select **Add task** in a board column, or **New Task** in the header. The column's status is prefilled. Empty boards still have all three columns.
2. Enter a **Title** and choose the **Project**. A single selected project is prefilled; with several selected projects, choose the intended one. The project supplies the class. Officers see only their own class's projects.
3. Enter **Start date** (today by default), **Due date** and **Estimated hours** (0 or more). Deliverables, instructions and full reference addresses are optional.
4. Open **Assigned members** to browse eligible members and officers. Type part of a name to filter choices; capitalization does not matter. Use Arrow keys and Enter, or click a name. Selected names stay selected when the search changes; use a name's remove button to remove it. Choose an optional **Primary contact** from the selected assignees.
5. Select **Create Task**. When started from the board, you return to the same filters. A task appears once on each matching assignee's subteam board. An unassigned task appears only in team/project views; the save confirmation links to its project board. Error messages keep entered information, and **Cancel** returns without saving.
6. To edit, open the task and select **Edit task**. Removing an assignee ends that assignment period; it preserves past hours and history. Reassigning them starts a new period.

## Prerequisites and blockers

On the task form, leaders can select **Prerequisite tasks** within the same class. A task with unfinished prerequisites shows **Blocked**. Its detail page shows each prerequisite's status, assignees and link to the shared task page. Completing all prerequisites clears the blocked indicator. Dependencies do not change dates or automatically complete another task. Self-links and circular chains are refused. Members may update their assigned task's status but cannot edit prerequisites.

## Task history

Open a task you manage and read **History**. Each line gives the date and time, who acted, and what happened in words, for example "Olivia Officer removed Bailey Member" or "changed the status from Backlog to In progress". The newest entry is first, starting with the task creator and initial status. History cannot be edited or deleted. Tasks with history are retained.

## Board summary and hours (the project dashboard)

The task board doubles as the leader dashboard described in the acceptance tests.

1. Select **Tasks**. Each column heading shows how many tasks are in it, and any unfinished task past its due date shows a red **Overdue** label.
2. Choose a **Project**, team, subteam or search, and select **Apply**. The line above the board shows how many tasks are overdue and the actual hours against the estimate for the tasks shown.
3. Scroll to **Hours by member** below the board (or select its link above the board). Set **Hours from** and **Hours to** (both dates are included) and select **Show hours**. Each member's actual hours are shown against their assigned-task estimate as a chart and as a table with the difference.

## Timeline

1. Select **Timeline**. Each task is a bar from its start date to its due date, grouped by team and subteam. Gray is Backlog, blue is In progress, green is Completed, and red stripes mean overdue. The red vertical line is today.
2. Use the search, team and subteam filters, then select **Apply**. The chart covers every task shown, from the earliest start date to the latest due date.
3. Select **Download timeline CSV** to save the task rows represented by the filtered chart, including the start and due dates. Rows marked Earlier or Later are included, as they are in the readable date list.
4. Scroll the chart sideways (with a trackpad, Shift + mouse wheel, or the arrow keys after selecting the chart) to see earlier and later dates; task names stay in view. The chart opens at today, and **Jump to today** returns there. Dates more than 26 weeks back or 52 weeks ahead are not drawn; those rows say "Earlier" or "Later".
5. **Dates as a list** below the chart gives the same start and due dates in text.

## Teams, subteams and projects

1. Select **Teams**. Each class lists its subteams and its team-level projects.
2. Use **Add subteam** to create a subteam. To create a project, select **Add project**, choose its parent team, enter its name and save. Every subteam of that class can contribute; no participant list is needed.
3. Select **Rename** to change a name. Its parent team stays fixed in the form. Use **Archive** to remove a group from everyday lists while retaining its records.
4. Archived groups appear under **Archived**. Select one to see its tasks and hours, or select **Restore** to bring it back.

The Chief Engineer manages every team. Officers manage subteams and projects across their own team only.

## Subteam rosters

1. Select **Teams**, then a subteam's name, and find **Subteam roster**. Chief Engineers manage every roster; officers manage their own class. Members cannot open roster management.
2. Select an approved person under **Transfer approved person to this roster**, then **Transfer to roster**. Their single membership moves in one save; this does not assign a task.
3. Each row shows the person's assigned work and project, or **No assigned work**. Actual hours are 0 when none were recorded in the selected scope. Choose a project and **Hours from/to**, then **Apply roster scope**, to narrow work and dated hours.
4. To move someone out, select a destination beside their name and **Transfer membership**. Accounts, task IDs, assignment history and hours remain. Their active assignments determine the resulting subteam board visibility.

Each member and officer has exactly one membership. Chief Engineers have none and cannot be task assignees. Cross-class moves require resolving incompatible active assignments first. Zero recorded hours does not establish availability.

## Download reports

1. As a Chief Engineer or officer, apply the project, team(s), subteam, member, search and task-date filters on **Tasks**. A project filter combines work across its class's subteams; add a subteam filter to narrow it further.
2. Select **Download CSV** for the task rows matching that view. The file includes task, project, class, subteam, assignees, status, start/due dates, estimated hours and actual hours.
3. Select **Download member hours** for each relevant member's total, including members with no assignments or hours. **Download project hours** groups the same scoped hours by project. A single Class column identifies the parent team; it is not duplicated.
4. **Hours from/to** use the date the work was recorded for; both endpoint dates are included. Member/date filters apply equally to the displayed summary, task-card actual hours and downloaded totals. Shared task estimates are counted once in the project total.
5. Open the CSV in Excel or Google Sheets. Empty task results produce column headings; member reports still show relevant zero-hour members. Formula-looking names or task titles are exported as literal text for spreadsheet safety.

Members have no export controls. Direct requests are denied. Officers' downloads contain only their own class's permitted work, even if a request supplies another class's filters.

## Messages and what to do

These are the messages only leaders can meet. Messages every person can meet are in the Member guide.

| Message | What it means | What to do |
| --- | --- | --- |
| Title can't be blank (or another field "can't be blank") | A required field is empty. | Fill in the field named next to the message and save again. |
| Estimated hours is not a number | Letters or symbols were typed where a number is needed. | Type digits only, for example `1` or `2.5`, and save again. |
| Estimated hours must be greater than or equal to 0 | A negative estimate was entered. | Enter 0 or more. |
| Due date must be on or after the start date | The due date is earlier than the start date. | Choose a due date on or after the start date. |
| End date must be on or after the start date | Under Hours by member, Hours to is earlier than Hours from. | Choose a later Hours to date, or select Clear. |
| Start date is not a valid date / End date is not a valid date | Hours by member could not read a date. | Pick the date with the date picker or type it as YYYY-MM-DD. |
| Reference links must each be a full web address starting with http:// or https:// | A reference link is incomplete. | Put one full address per line, for example `https://example.com/plan`. |
| You can manage only tasks on your own team. | An officer tried to change another team's task. | Ask that team's officer or the Chief Engineer. |
| Project must belong to your team | An officer chose another team's project. | Choose one of your team's projects. |
| You can manage only your own team's subteams and projects. | An officer tried to change another team's group. | Ask the Chief Engineer. |
| Choose an approved member or officer from this class. | The selected person is unavailable or belongs to another class. | Select an approved person from this class. |
| Choose a destination subteam to transfer this membership. | Members and officers cannot be left without a membership. | Choose another subteam in the class and transfer in one save. |
| This person does not belong to this roster. | The membership changed or the wrong person was selected. | Refresh the roster. |
| Prerequisite task would create a loop / cannot be the task itself | The proposed dependency is circular. | Select a different prerequisite. |
| Primary contact must be an active assignee | The selected contact is not assigned. | Assign them first or choose another active assignee. |
| Project must exist | The task has no valid project. | Select a permitted project. |
| Tasks with recorded history or logged hours cannot be deleted. | These records preserve project history. | Retain the task; archive its project when appropriate. |
| Name has already been taken | Another team, subteam or project in that place already uses the name. | Choose a different name, or find the existing entry and rename that one. |
| Assignees must be eligible members of this project's team | A chosen person is not an approved member or officer of the project's class. | Remove that person, or choose a project in their class. |
| Prerequisites must be tasks you may manage within this team / Prerequisite task must belong to the same team | A prerequisite is in another class. | Select prerequisites from the same class only. |
| Project must be active and belong to an active class | The project or its class is archived. | Choose an active project, or restore it under Teams. |
| Project would invalidate active assignments / Team would invalidate active assignments / Subteam would invalidate active assignments; resolve them before transferring teams | The move would leave assigned people on a task outside their class. | Remove or reassign those people first, then repeat the move. |
| Project cannot move to another team while prerequisites are linked / Team cannot change while tasks have prerequisites; resolve the links first | Prerequisite links tie the task to its current class. | Remove the prerequisite links, then move it. |
| User must be assigned to the task / User must belong to the task's team and have a subteam membership / User cannot be an administrator | The person cannot hold that task or roster place. | Choose an approved member or officer of the task's class. |
| Status requires an authorized person making the change / Actor must be authorized to change this task | The change was sent by someone not allowed to make it. | Sign in as an assignee or the class's officer and try again. |
| Is primary contact requires an active assignment / Unassigned at must include an authorized remover and be on or after assignment | An assignment record was changed in a way the history does not allow. | Reopen the task, select Edit task and make the change there. |
