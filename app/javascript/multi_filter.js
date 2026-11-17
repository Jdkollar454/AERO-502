// Checkbox dropdowns for multi-value filters: keep the summary text in sync and close
// the menu on outside clicks or Escape. Without JavaScript the <details> still works.
function summarize(menu) {
  const checked = Array.from(menu.querySelectorAll("input[type=checkbox]:checked"));
  const summary = menu.querySelector("[data-multi-filter-summary]");
  if (!summary) return;
  if (checked.length === 0) summary.textContent = menu.dataset.emptyText || "None";
  else if (checked.length === 1) summary.textContent = checked[0].closest("label").textContent.trim();
  else summary.textContent = `${checked.length} selected`;
}

document.addEventListener("change", event => {
  const menu = event.target.closest("[data-multi-filter]");
  if (menu) summarize(menu);
});

document.addEventListener("click", event => {
  document.querySelectorAll("[data-multi-filter][open]").forEach(menu => {
    if (!menu.contains(event.target)) menu.open = false;
  });
});

document.addEventListener("keydown", event => {
  if (event.key !== "Escape") return;
  const menu = event.target.closest?.("[data-multi-filter][open]");
  if (!menu) return;
  menu.open = false;
  menu.querySelector("summary").focus();
});

// Only one menu open at a time.
document.addEventListener("toggle", event => {
  const menu = event.target;
  if (!menu.matches?.("[data-multi-filter]") || !menu.open) return;
  document.querySelectorAll("[data-multi-filter][open]").forEach(other => {
    if (other !== menu) other.open = false;
  });
}, true);
