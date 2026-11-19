class User < ApplicationRecord
     has_secure_password validations: false
     enum :role, { member: 0, officer: 1, chief_engineer: 2 }, validate: true
     has_one :membership, inverse_of: :user, autosave: true, dependent: :destroy
     has_one :subteam, through: :membership
     has_one :team, through: :subteam
     has_many :task_assignments, dependent: :restrict_with_error
     has_many :active_assignments, -> { active }, class_name: "TaskAssignment"
     has_many :assigned_tasks, through: :active_assignments, source: :task
     has_many :time_entries, dependent: :restrict_with_error
     has_many :created_tasks, class_name: "Task", foreign_key: :creator_id, inverse_of: :creator, dependent: :restrict_with_error
     has_many :made_assignments, class_name: "TaskAssignment", foreign_key: :assigned_by_id, dependent: :restrict_with_error
     has_many :ended_assignments, class_name: "TaskAssignment", foreign_key: :unassigned_by_id, dependent: :restrict_with_error
     has_many :status_changes, class_name: "TaskStatusChange", foreign_key: :actor_id, dependent: :restrict_with_error

     scope :in_teams, ->(ids) { joins(membership: :subteam).where(subteams: { team_id: ids }) }
     scope :in_subteam, ->(id) { joins(:membership).where(memberships: { subteam_id: id }) }
     scope :directory, -> { where(permanently_removed_at: nil) }
     scope :listed, -> { directory.where(removed_at: nil) }
     scope :allowed_to_sign_in, -> { listed.where(access_revoked_at: nil) }
     scope :assignable, -> { allowed_to_sign_in.where(role: [ :member, :officer ]).joins(:membership) }

     # Chiefs have no team membership and may add themselves to any team's work.
     def self.task_candidates(team_ids, actor:)
          candidates = where(id: assignable.in_teams(team_ids).select(:id))
          actor.chief_engineer? ? candidates.or(allowed_to_sign_in.where(id: actor.id)) : candidates
     end

     ROLE_LABELS = { "member" => "Member", "officer" => "Officer", "chief_engineer" => "Chief Engineer" }.freeze
     ROLES_WITH_ARTICLE = { "member" => "a Member", "officer" => "an Officer", "chief_engineer" => "a Chief Engineer" }.freeze

     before_validation :normalize_email
     validate :preserve_last_active_chief_engineer
     validate :preserve_permanent_removal
     validates :name, presence: true
     validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
     validate :membership_matches_role
     validate :assignments_stay_eligible

     def subteam
          membership&.subteam unless membership&.marked_for_destruction?
     end

     def subteam=(value)
          if value
               (membership || build_membership).subteam = value
          elsif membership&.persisted?
               membership.mark_for_destruction
          else
               self.membership = nil
          end
     end

     def subteam_id
          subteam&.id
     end

     def subteam_id=(value)
          self.subteam = value.present? ? Subteam.find_by(id: value) : nil
     end

     def team
          subteam&.team
     end

     def team_id
          team&.id
     end

     # Existing callers may submit a class as a validation hint; it is not stored.
     def team=(value)
          @requested_team_id = value&.id
     end

     def team_id=(value)
          @requested_team_id = value.presence&.to_i
     end

     def role_label
          ROLE_LABELS.fetch(role)
     end

     def role_with_article
          ROLES_WITH_ARTICLE.fetch(role)
     end

     def access_revoked?
          access_revoked_at.present? || removed? || permanently_removed?
     end

     def removed?
          removed_at.present?
     end

     def permanently_removed?
          permanently_removed_at.present?
     end

     # Retain attribution and foreign keys, but erase credentials and directory access.
     def permanently_remove(confirmation_name:)
          with_access_lock do
               errors.clear
               if permanently_removed?
                    errors.add(:base, "This person was permanently removed and cannot be restored.")
               elsif !removed?
                    errors.add(:base, "Move this person to Removed people before permanently removing them.")
               elsif confirmation_name.to_s != name
                    errors.add(:confirmation_name, "must match the person's name exactly")
               else
                    next update(permanently_removed_at: Time.current, access_revoked_at: access_revoked_at || Time.current,
                                email: "removed-#{id}-#{SecureRandom.uuid}@example.invalid", password_digest: nil)
               end
               false
          end
     end

     def restore_access
          with_access_lock { update(access_revoked_at: nil, removed_at: nil) }
     end

     def authenticate_password_sign_in(password)
          password_digest.present? && authenticate(password)
     end

     def leader?
          officer? || chief_engineer?
     end

     def can_manage?(task)
          !access_revoked? && (chief_engineer? || (officer? && task.team_id == team_id))
     end

     def can_work_on?(task)
          !access_revoked? && task.assignee_ids.include?(id)
     end

     private

     # Use the same lock order as membership changes, then reload to reject stale forms.
     def with_access_lock
          self.class.transaction do
               self.class.connection.execute("SELECT pg_advisory_xact_lock(5023001)")
               lock!
               yield
          end
     end

     def preserve_permanent_removal
          return unless permanently_removed_at_in_database.present?
          return if (changes_to_save.keys - [ "updated_at" ]).empty?

          errors.add(:base, "This person was permanently removed and cannot be changed or restored.")
     end

     def membership_matches_role
          if chief_engineer?
               errors.add(:subteam, "must be blank for a Chief Engineer") if subteam
          else
               errors.add(:subteam, "is required for a member or officer") unless subteam
               if @requested_team_id && subteam && subteam.team_id != @requested_team_id
                    errors.add(:subteam, "must belong to the person's team")
               end
          end
     end

     def assignments_stay_eligible
          return if chief_engineer?
          return unless persisted? && task_assignments.active.joins(task: :project).where.not(projects: { team_id: team_id }).exists?

          errors.add(:subteam, "cannot change teams until incompatible active assignments are resolved")
     end

     def preserve_last_active_chief_engineer
          return unless role_in_database == "chief_engineer" && access_revoked_at_in_database.nil?
          return if chief_engineer? && !access_revoked?

          self.class.connection.execute("SELECT pg_advisory_xact_lock(260026)")
          return if self.class.chief_engineer.allowed_to_sign_in.where.not(id: id).exists?

          errors.add(:base, "At least one active Chief Engineer is required. Add another Chief Engineer before removing this role or access.")
     end

     def normalize_email
          self.email = email.to_s.strip.downcase
     end
end
