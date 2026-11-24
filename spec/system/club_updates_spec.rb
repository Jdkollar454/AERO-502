require "rails_helper"

RSpec.describe "Club administration updates", type: :system do
     before do
          driven_by :selenium, using: :headless_chrome, screen_size: [ 1280, 1000 ] do |options|
               options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"].present?
               options.add_argument("--no-sandbox") if Process.uid.zero?
               options.add_argument("--disable-dev-shm-usage")
               options.add_argument("--screen-info={1600x1200}")
               options.add_preference("credentials_enable_service", false)
               options.add_preference("profile.password_manager_leak_detection", false)
          end
          page.driver.browser.manage.window.resize_to(1280, 1000)
     end

     def sign_in_chief
          visit login_path
          fill_in "Email address", with: users(:chief).email
          fill_in "Password", with: "password"
          click_button "Sign in", exact: true
          expect(page).to have_text("Task Board")
     end

     it "lets the chief find themselves, save the assignment and see it in My Tasks" do
          sign_in_chief
          visit edit_task_path(tasks(:spar_check))
          fill_in "Assigned members", with: users(:chief).name
          find("#task_member_search").send_keys(:arrow_down, :enter)
          expect(page).to have_css('button[aria-label="Remove Casey Chief"]')
          select users(:chief).name, from: "Primary contact (optional)"
          click_button "Update Task"
          expect(page).to have_text("Task was updated successfully.")
          expect(page).to have_text("Record actual hours")
          click_link "My Tasks", exact: true
          expect(page).to have_link("Verify spar dimensions")
     end

     it "searches, confirms removal and restores the same person through the directory" do
          sign_in_chief
          click_link "People", exact: true
          fill_in "Search people", with: "morgan"
          click_button "Search", exact: true
          expect(page).to have_css("tbody tr", count: 1)
          find('a[aria-label="Remove person Morgan Member"]').click
          expect(page).to have_text("Their task assignments, logged hours and task history will stay.")
          click_link "Cancel", exact: true
          expect(users(:member).reload).not_to be_removed
          find('a[aria-label="Remove person Morgan Member"]').click
          click_button "Remove person", exact: true
          expect(page).to have_text("Their tasks, hours and history are kept.")
          expect(page).not_to have_css("tbody th", text: "Morgan Member")
          click_link "Removed people", exact: true
          expect(page).to have_css("tbody th", text: "Morgan Member")
          find('button[aria-label="Restore person Morgan Member"]').click
          expect(page).to have_css("tbody th", text: "Morgan Member")
          expect(users(:member).time_entries.sum(:hours)).to eq(2.5)
     end

     it "confirms permanent removal in the browser and keeps the person's work" do
          users(:member).update!(access_revoked_at: Time.current)
          sign_in_chief
          click_link "People", exact: true
          click_link "Removed people", exact: true
          click_link "Permanently remove", exact: true
          expect(page).to have_text("This cannot be undone.")
          click_link "Cancel", exact: true
          expect(page).to have_css("tbody th", text: "Morgan Member")
          click_link "Permanently remove", exact: true
          fill_in "Type their full name to confirm", with: "Wrong name"
          click_button "Permanently remove", exact: true
          expect(page).to have_text("must match the person's name exactly")
          expect(users(:member).reload).not_to be_permanently_removed
          visit permanent_removal_user_path(users(:member))
          fill_in "Type their full name to confirm", with: users(:member).name
          click_button "Dark mode", exact: true unless page.has_css?('html[data-theme="dark"]', wait: 0)
          expect(page).to have_css('html[data-theme="dark"]')
          page.save_screenshot(Rails.root.join("tmp/screenshots/permanent_removal_dark.png"))
          page.driver.browser.manage.window.resize_to(390, 844)
          expect(page.evaluate_script("document.documentElement.scrollWidth <= innerWidth + 1")).to be(true)
          page.save_screenshot(Rails.root.join("tmp/screenshots/permanent_removal_mobile.png"))
          click_button "Permanently remove", exact: true
          expect(page).to have_text("Their contributions are kept, but their account cannot be restored.")
          expect(page).not_to have_css("tbody th", text: "Morgan Member")
          visit task_path(tasks(:wing_test))
          expect(page).to have_text("Morgan Member")
          expect(page).to have_text("2.5 hours")
     end

     it "follows the device theme and remembers manual choices across navigation and reloads" do
          visit login_path
          page.execute_script("localStorage.removeItem('aero-theme')")
          page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "dark" } ])
          page.refresh
          expect(page).to have_css('html[data-theme="dark"]')
          expect(page).to have_css('[data-theme-toggle][aria-pressed="true"]')
          click_button "Dark mode", exact: true
          expect(page).to have_css('html[data-theme="light"]')
          sign_in_chief
          click_link "People", exact: true
          expect(page).to have_css('html[data-theme="light"]')
          click_button "Dark mode", exact: true
          page.refresh
          expect(page).to have_css('html[data-theme="dark"]')
          expect(page.evaluate_script("getComputedStyle(document.body).backgroundColor")).to eq("rgb(22, 20, 25)")
          expect(page.evaluate_script("getComputedStyle(document.querySelector('input[type=search]')).backgroundColor")).to eq("rgb(25, 23, 30)")
          page.save_screenshot(Rails.root.join("tmp/screenshots/people_dark.png"))
          page.driver.browser.manage.window.resize_to(390, 844)
          expect(page.evaluate_script("document.documentElement.scrollWidth <= innerWidth + 1")).to be(true),
               page.evaluate_script("JSON.stringify({width: innerWidth, scroll: document.documentElement.scrollWidth, nodes: [...document.querySelectorAll('body *')].filter(el => el.getBoundingClientRect().right > innerWidth).map(el => [el.tagName, el.className, el.getBoundingClientRect().right])})")
          page.save_screenshot(Rails.root.join("tmp/screenshots/people_dark_mobile.png"))
          click_link "Tasks", exact: true
          expect(page).to have_css('html[data-theme="dark"]')
          page.driver.browser.manage.window.resize_to(1280, 1000)
          page.save_screenshot(Rails.root.join("tmp/screenshots/board_dark.png"))
     end
end
