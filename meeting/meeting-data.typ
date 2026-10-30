// =============================================================================
// MEETING DATA - small constructors for the meeting tables
// Corso di Gestione dei Progetti Software - Università degli Studi di Salerno
// =============================================================================
// A meeting is described by plain `let` variables in its agenda.typ; the
// minuta imports them (`#import "agenda.typ": *`) and overrides only what
// actually happened at the meeting, e.g.
//
//   #let ai-1 = by-id(action-items, "AI1") + (status: "Chiusa", closed: "10/11/2026")
//
// Prefer by-id() over .at(n): positional lookups break silently when the
// list is reordered.
// =============================================================================

// A task shown in the "Attività pianificate" table (same in agenda and minuta).
#let task(name, assignee: "", due: none, status: "", notes: "") = (
  name: name,
  assignee: assignee,
  due: due,
  status: status,
  notes: notes,
)

// An action item. The agenda only needs id, description, assignee and due;
// the minuta additionally fills opened, priority, status, closed and notes.
// Every field has a default, so partial items are fine.
#let action-item(
  id,
  description,
  assignee: "",
  opened: none,
  priority: "Media",
  status: "Aperta",
  due: none,
  closed: none,
  notes: "",
) = (
  id: id,
  description: description,
  opened: opened,
  priority: priority,
  assignee: assignee,
  status: status,
  due: due,
  closed: closed,
  notes: notes,
)

// True when an action item is completed: either its status is "Chiusa" or it
// carries an actual completion date. Used by ai-table to hide finished items.
#let is-closed(it) = {
  it.at("status", default: "") == "Chiusa" or it.at("closed", default: none) != none
}

// Finds an item by its id, e.g. by-id(action-items, "AI1"). Fails loudly when
// the id does not exist, instead of rendering the wrong row.
#let by-id(items, id) = {
  let found = items.find(it => it.at("id", default: none) == id)
  assert(found != none, message: "no item with id \"" + id + "\"")
  found
}
