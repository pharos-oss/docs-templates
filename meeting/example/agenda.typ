// =============================================================================
// AGENDA - facts of this meeting and the agenda document itself.
// Example meeting: copy this folder to start a real one (e.g. docs/meetings/2026-11-10/).
// The facts below are shared with the minuta: minuta.typ imports this file
// (`#import "agenda.typ": *`) and only overrides what actually happened.
// CLI: typst compile --root . meeting/example/agenda.typ
// =============================================================================
#import "../template.typ": agenda-template, task-table, ai-table
#import "../meeting-data.typ": task, action-item
// Once copied into the docs repository, adjust the two imports above to the new
// location: with the submodule in `docs/templates/` and the meeting in
// `docs/meetings/DATA_MEETING/`, they become:
//
//   #import "../../templates/meeting/template.typ": agenda-template, task-table, ai-table
//   #import "../../templates/meeting/meeting-data.typ": task, action-item

// General info
#let project-name = "Progetto Pharos"
#let number = 1
#let date = "10/11/2026"

// Time slot and place
#let start-time = "14:00"
#let end-time = "15:30"
#let place = "Aula 12, Dipartimento di Informatica"

// Roles
#let facilitator = "Mario Rossi"
#let timekeeper = "Luca Verdi"
#let minute-taker = "Giulia Bianchi"

// Section content reused by the minuta
#let objective = [
  Allineamento sullo stato dei primi moduli della piattaforma e definizione del
  piano di lavoro per la prossima settimana.
]
#let communications = [
  - È disponibile il logo ufficiale del progetto, da usare nella documentazione;
  - È stata comunicata la data della prima revisione: 30/11/2026.
]

// Planned activities
#let tasks = (
  task("Rubrica di primo contatto", assignee: "M. Rossi", due: "17/11/2026", status: "In corso"),
  task("Meccanismo di antipanico", assignee: "L. Verdi", due: "24/11/2026", status: "In corso"),
  task("Diario delle evidenze", assignee: "G. Bianchi", due: "01/12/2026", status: "Da iniziare"),
)

// Action items inherited from the previous meeting, as they stood at its end.
// In a real meeting chain you can import them straight from the previous
// minuta: `#import "../<previous-meeting>/minuta.typ": updated-action-items
// as action-items`. The "Action items" section renders this table.
#let action-items = (
  action-item("AI1", [Definire lo schema del DB per le segnalazioni], assignee: "L. Verdi", due: "16/11/2026"),
  action-item("AI2", [Raccolta dei requisiti per il modulo di self-assessment], assignee: "M. Rossi", due: "19/11/2026"),
)

#show: agenda-template.with(
  project: project-name,
  number: number,
  date: date,
  start-time: start-time,
  end-time: end-time,
  place: place,
  facilitator: facilitator,
  timekeeper: timekeeper,
  minute-taker: minute-taker,
)

= Obiettivo (tempo allocato: 10 minuti)
#objective

= Comunicazioni (tempo allocato: 5 minuti)
#communications

= Status (tempo allocato: 20 minuti)

== Attività pianificate
#task-table(tasks)

#pagebreak()

== Action items
#ai-table(action-items)

= Discussione (tempo allocato: 30 minuti)
*I1:* Quale libreria usare per i questionari di self-assessment?

= Wrap up (tempo allocato: 10 minuti)
Assegnazione dei nuovi action items e breve retrospective sullo svolgimento del meeting.
