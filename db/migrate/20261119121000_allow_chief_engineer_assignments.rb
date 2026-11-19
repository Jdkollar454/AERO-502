class AllowChiefEngineerAssignments < ActiveRecord::Migration[8.1]
     def up
          replace_integrity_function(chief_assignments: true)
     end

     def down
          if select_value("SELECT EXISTS (SELECT 1 FROM task_assignments a JOIN users u ON u.id = a.user_id WHERE a.unassigned_at IS NULL AND u.role = 2)")
               raise ActiveRecord::IrreversibleMigration, "Unassign Chief Engineers before rolling back chief assignment support. Their assignment history will remain."
          end
          replace_integrity_function(chief_assignments: false)
     end

     private

     def replace_integrity_function(chief_assignments:)
          execute <<~SQL
               CREATE OR REPLACE FUNCTION public.aero_validate_integrity() RETURNS trigger
                   LANGUAGE plpgsql
                   AS $$
               BEGIN
                    IF EXISTS (
                         SELECT 1 FROM users u LEFT JOIN memberships m ON m.user_id = u.id
                         WHERE (u.role = 2 AND m.user_id IS NOT NULL) OR (u.role <> 2 AND m.user_id IS NULL)
                    ) THEN RAISE EXCEPTION 'Members and officers require exactly one subteam; administrators require none.' USING ERRCODE = '23514'; END IF;
                    IF EXISTS (
                         SELECT 1 FROM task_assignments a JOIN tasks t ON t.id = a.task_id
                         JOIN projects p ON p.id = t.project_id JOIN users u ON u.id = a.user_id
                         LEFT JOIN memberships m ON m.user_id = a.user_id
                         LEFT JOIN subteams s ON s.id = m.subteam_id
                         WHERE a.unassigned_at IS NULL #{chief_assignments ? "AND u.role <> 2" : ""} AND (m.user_id IS NULL OR s.team_id <> p.team_id)
                    ) THEN RAISE EXCEPTION 'An active assignee must belong to the project team; resolve assignments before transferring ownership.' USING ERRCODE = '23514'; END IF;
                    IF EXISTS (
                         SELECT 1 FROM tasks t LEFT JOIN LATERAL (
                              SELECT to_status FROM task_status_changes WHERE task_id = t.id ORDER BY created_at DESC, id DESC LIMIT 1
                         ) latest ON TRUE WHERE latest.to_status IS NULL OR latest.to_status <> t.status
                    ) THEN RAISE EXCEPTION 'Task status must match its complete status history.' USING ERRCODE = '23514'; END IF;
                    IF EXISTS (
                         SELECT 1 FROM task_dependencies d JOIN tasks t ON t.id = d.task_id JOIN projects p ON p.id = t.project_id
                         JOIN tasks r ON r.id = d.prerequisite_task_id JOIN projects q ON q.id = r.project_id WHERE p.team_id <> q.team_id
                    ) THEN RAISE EXCEPTION 'Prerequisites must stay within the same team.' USING ERRCODE = '23514'; END IF;
                    IF EXISTS (
                         WITH RECURSIVE paths(start_id, end_id) AS (
                              SELECT task_id, prerequisite_task_id FROM task_dependencies
                              UNION SELECT paths.start_id, d.prerequisite_task_id FROM paths JOIN task_dependencies d ON d.task_id = paths.end_id
                         ) SELECT 1 FROM paths WHERE start_id = end_id
                    ) THEN RAISE EXCEPTION 'Prerequisites cannot form a loop.' USING ERRCODE = '23514'; END IF;
                    RETURN NULL;
               END $$;
          SQL
     end
end
