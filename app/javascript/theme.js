// Apply before styles paint; remember the choice without requiring an account.
(() => {
  const key = "aero-theme";
  const system = window.matchMedia("(prefers-color-scheme: dark)");
  let preference;
  try { preference = localStorage.getItem(key); } catch (_) { /* Storage may be disabled. */ }
  if (preference !== "light" && preference !== "dark") preference = null;

  const apply = () => {
    const theme = preference || (system.matches ? "dark" : "light");
    document.documentElement.dataset.theme = theme;
    document.querySelectorAll("[data-theme-toggle]").forEach(button => {
      button.hidden = false;
      button.setAttribute("aria-pressed", String(theme === "dark"));
      button.title = theme === "dark" ? "Switch to light mode" : "Switch to dark mode";
    });
  };

  document.addEventListener("click", event => {
    if (!event.target.closest("[data-theme-toggle]")) return;
    preference = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    try { localStorage.setItem(key, preference); } catch (_) { /* Keep working for this page. */ }
    apply();
  });
  window.addEventListener("storage", event => {
    if (event.key !== key && event.key !== null) return;
    preference = ["light", "dark"].includes(event.newValue) ? event.newValue : null;
    apply();
  });
  system.addEventListener("change", apply);
  document.addEventListener("DOMContentLoaded", apply);
  document.addEventListener("turbo:load", apply);
  apply();
})();
