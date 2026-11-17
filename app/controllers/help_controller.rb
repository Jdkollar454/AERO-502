# Shows the guides in docs/ inside the website, so the guide in the repository
# and the one people read are always the same. Each role sees a tab for its
# own guide: the member guide is open to everyone (even signed out, so people
# who cannot sign in can still read what to do), the officer guide to leaders,
# and the Chief Engineer and administrator guides to the Chief Engineer.
class HelpController < ApplicationController
     Guide = Struct.new(:key, :label, :file, :audience, :denied_message) do
          def path
               Rails.root.join("docs", file)
          end

          def open_to?(user)
               case audience
               when :everyone then true
               when :leaders then user&.leader? || false
               else user&.chief_engineer? || false
               end
          end
     end

     GUIDES = [
          Guide.new(nil, "Member guide", "USER_GUIDE.md", :everyone, nil),
          Guide.new("officer", "Officer guide", "OFFICER_GUIDE.md", :leaders,
                    "Access denied. The officer guide is available to team officers and the Chief Engineer."),
          Guide.new("chief", "Chief Engineer guide", "CHIEF_ENGINEER_GUIDE.md", :chief_engineer,
                    "Access denied. The Chief Engineer guide is available to the Chief Engineer."),
          Guide.new("admin", "Administrator guide", "ADMIN_GUIDE.md", :chief_engineer,
                    "Access denied. The administrator guide is available to the Chief Engineer.")
     ].freeze

     before_action :set_guide
     before_action :require_sign_in, unless: -> { @guide.audience == :everyone }
     before_action :ensure_guide_access

     def show
          renderer = Redcarpet::Render::HTML.new(with_toc_data: true, escape_html: true)
          @guides = GUIDES.select { |guide| guide.open_to?(current_user) }
          @guide_html = Redcarpet::Markdown.new(renderer, tables: true, autolink: true).render(@guide.path.read)
     end

     def restart
          send_file Rails.root.join("docs/RESTART_GUIDE.pdf"), type: "application/pdf", disposition: "attachment"
     end

     private

     # An unknown guide name falls back to the member guide.
     def set_guide
          key = action_name == "restart" ? "admin" : params[:guide]
          @guide = GUIDES.find { |guide| guide.key == key } || GUIDES.first
     end

     def ensure_guide_access
          deny_access(@guide.denied_message) unless @guide.open_to?(current_user)
     end
end
