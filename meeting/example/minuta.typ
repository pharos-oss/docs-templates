// =============================================================================
// MINUTA - example meeting. It reuses every fact from agenda.typ and only adds
// what actually happened: attendees, updated action items, the outcome of the
// discussion, the updated action items table and the next meeting.
// CLI: typst compile --root . meeting/example/minuta.typ
// =============================================================================
#import "../template.typ": minuta-template, task-table, ai-table
#import "../meeting-data.typ": action-item, by-id
#import "agenda.typ": *
// Once copied into the docs repository, adjust the first two imports above to
// the new location: with the submodule in `docs/templates/` and the meeting in
// `docs/meetings/DATA_MEETING/`, they become:
//
//   #import "../../templates/meeting/template.typ": minuta-template, task-table, ai-table
//   #import "../../templates/meeting/meeting-data.typ": action-item, by-id
//
// The `agenda.typ` import needs no change: the minuta sits next to the agenda.

// Who attended
#let present = (facilitator, timekeeper, minute-taker)
#let absent = ("Giovanni Storti",)

// How the inherited action items actually went: start from them and update
#let ai-1 = by-id(action-items, "AI1") + (status: "Chiusa", closed: "10/11/2026")
#let ai-2 = by-id(action-items, "AI2") + (status: "In corso", notes: [In attesa dei requisiti definitivi])

// New action item opened in the wrap-up (opening date = meeting date)
#let ai-3 = action-item("AI3", [Valutare LimeSurvey: setup di una prova pilota], assignee: "G. Bianchi", opened: date, due: "19/11/2026")

// The full table after this meeting, closed items included --
// this is what the next meeting will inherit
#let updated-action-items = (ai-1, ai-2, ai-3)

#show: minuta-template.with(
  project: project-name,
  number: number,
  date: date,
  start-time: start-time,
  end-time: end-time,
  place: place,
  facilitator: facilitator,
  timekeeper: timekeeper,
  minute-taker: minute-taker,
  present: present,
  absent: absent,
)

= Obiettivo (tempo allocato: 10 minuti)
#objective

= Comunicazioni (tempo allocato: 5 minuti)
#communications

= Status (tempo allocato: 20 minuti)

== Attività pianificate
#task-table(tasks)

== Action items
#ai-table(action-items, hide-closed: false)

= Discussione (tempo allocato: 30 minuti)
- *I1:* Quale libreria usare per i questionari di self-assessment?
  - *P1.1:* Typeform \
    \+ Interfaccia pronta e curata \
    \- Costo annuo
  - *P1.2:* LimeSurvey self-hosted \
    \+ Gratuito, dati ospitati in UE \
    \- Manutenzione da parte nostra
  - *R:* P1.2 -- vedi AI3

= Wrap up (tempo allocato: 10 minuti)
Assegnazione dei nuovi action items.

#ai-table(updated-action-items, extended: true)

Il meeting è terminato nei 60 minuti previsti; la prossima volta dedicare più tempo allo status.

= Data, ora e luogo del prossimo meeting
17/11/2026 alle ore 14:00, Aula 12
