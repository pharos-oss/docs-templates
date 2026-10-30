// =============================================================================
// MEETING TEMPLATES - Agenda and Minuta of a project meeting
// Corso di Gestione dei Progetti Software - Università degli Studi di Salerno
// =============================================================================
// The template provides the layout (cover, info card, header/footer, heading
// styles) plus two table components; every section is hand-written markup.
// Usage, from <meeting>/agenda.typ:
//
//   #import "../template.typ": agenda-template, task-table, ai-table
//   #show: agenda-template.with(project: "...", number: 1, date: "...")
//
//   = Obiettivo (tempo allocato: 10 minuti)
//   ...
//
// The minuta imports the facts from the agenda (`#import "agenda.typ": *`)
// and adds only what actually happened: attendees, updated action items, the
// discussion outcomes, the updated action items table and the next meeting.
// The meeting number is rendered as a subtitle, not inside the main title.
// NOTE: image paths in this file resolve relative to meeting/; when compiling
// from the CLI, use `typst compile --root . <meeting>/agenda.typ`.
// =============================================================================
#import "../common.typ": palette-primary, readable-text, table-style
#import "meeting-data.typ": is-closed

// Renders a value in a table cell, mapping `none` to an empty string.
#let as-text(v) = if v == none { "" } else { v }

// Table of planned tasks ("Attività pianificate").
#let task-table(tasks, primary-color: palette-primary) = {
  if tasks.len() > 0 {
    table(
      columns: (1.6fr, 1.2fr, 1.4fr, 0.9fr, 1.6fr),
      inset: 5pt,
      ..table-style(primary-color),
      ..("Task", "Responsabile", "Data Prevista di Completamento", "Status", "Note")
        .map(h => text(size: 8.5pt, weight: "bold", fill: readable-text(primary-color))[#h]),
      ..tasks.map(t => (t.name, t.assignee, t.due, t.status, t.notes).map(as-text)).flatten()
    )
  }
}

// Action items table. The agenda shows the planning columns and hides the
// completed items; the minuta (`extended: true`) shows every column and every
// item. `hide-closed` defaults to `none`: the table hides completed items
// unless it is extended, so the agenda filters them out and the minuta
// (both its initial and its wrap-up table) shows everything. Pass `true` or
// `false` to force either behaviour.
#let ai-table(items, extended: false, hide-closed: none,
              primary-color: palette-primary) = {
  let hide = if hide-closed == none { not extended } else { hide-closed }
  let shown = if hide { items.filter(it => not is-closed(it)) } else { items }
  if shown.len() > 0 {
    let head = if extended {
      ("Action Item", "Descrizione", "Data di Apertura", "Priorità", "Responsabile",
       "Status", "Data Prevista di Completamento", "Data Effettiva di Completamento", "Note")
    } else {
      ("Action Item", "Descrizione", "Data di Apertura", "Responsabile",
       "Data Prevista di Completamento")
    }
    let cols = if extended {
      (0.55fr, 1.55fr, 0.95fr, 0.55fr, 0.9fr, 0.55fr, 0.95fr, 0.95fr, 1fr)
    } else {
      (0.8fr, 2.4fr, 1.1fr, 1.3fr, 1.4fr)
    }
    table(
      columns: cols,
      inset: 4pt,
      ..table-style(primary-color),
      ..head.map(h => text(size: 8pt, weight: "bold", fill: readable-text(primary-color))[#h]),
      ..shown.map(it => {
        let row = if extended {
          (it.id, it.description, it.opened, it.priority, it.assignee,
           it.status, it.due, it.closed, it.notes)
        } else {
          (it.id, it.description, it.opened, it.assignee, it.due)
        }
        row.map(as-text)
      }).flatten()
    )
  }
}

// Shared layout for both documents; `kind` is "agenda" or "minuta". Sections
// are not predefined: they are the markup passed as `body`.
#let meeting-core(
  kind: "agenda",
  project: "",
  logo: "../assets/logo_pharos.png",
  number: none,
  date: "",
  start-time: "",
  end-time: "",
  place: "",
  facilitator: "",
  timekeeper: "",
  minute-taker: "",
  // Minuta only: who attended the meeting; the agenda ignores them.
  present: (),
  absent: (),
  // Style
  primary-color: palette-primary,
  header-line-1: [Laurea Magistrale in Informatica - Università di Salerno],
  header-line-2: [Corso di Gestione dei Progetti Software - Prof.ssa F. Ferrucci e Prof. F. Palomba],
  body
) = {
  let extended = kind == "minuta"
  let doc-title = if extended { "Minuta Meeting" } else { "Agenda Meeting" }
  let number-note = if number == none { [] } else { [n° #number] }

  // Page Configuration
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 2.5cm, bottom: 2.5cm),
    header: context {
      v(20pt)
      grid(
        columns: (auto, 1fr, auto),
        column-gutter: 12pt,
        align(horizon)[#image("../assets/logo_unisa.png", height: 1.15cm)],
        align(horizon)[
          #text(font: "Liberation Sans", size: 9pt, weight: "bold")[#header-line-1] \
          #text(font: "Liberation Sans", size: 8.5pt, style: "italic", fill: rgb("#333333"))[#header-line-2]
        ],
        align(horizon)[#if logo != none { image(logo, height: 1.6cm) }]
      )
      v(2pt)
      line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
    },
    footer: context {
      text(font: "Liberation Sans", size: 8.5pt, fill: rgb("#555555"))[
        #line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
        #v(-2pt)
        #grid(
          columns: (1fr, auto),
          align(left)[#text(tracking: 0.8pt)[#doc-title #number-note]],
          align(right)[Pag. #counter(page).display("1 | 1", both: true)]
        )
      ]
    }
  )

  // Typography & Paragraphs
  set text(font: "Liberation Sans", size: 10pt, lang: "it")
  set par(justify: true, leading: 0.65em)
  set heading(numbering: "1.")

  show heading.where(level: 1): it => block(above: 1.4em, below: 0.8em)[
    #set text(weight: "bold", fill: primary-color, size: 13pt)
    #it.body
  ]

  show heading.where(level: 2): it => block(above: 1em, below: 0.6em)[
    #set text(weight: "bold", fill: primary-color, size: 11.5pt)
    #it.body
  ]

  // Cover: logo, project name, title, number (subtitle) and date
  v(0.8cm)
  block(width: 100%)[
    #set par(justify: false)
    #align(center)[
      #if logo != none [#image(logo, height: 2cm)#v(8pt)]
      #text(weight: "bold", size: 11pt)[#project]
      #v(14pt)
      #text(size: 30pt, weight: "bold", fill: primary-color)[#doc-title]
      #if number != none [#v(2pt)#text(size: 20pt, weight: "medium", fill: primary-color)[#number-note]]
      #v(6pt)
      #text(size: 12pt)[#date]
    ]
  ]
  v(1em)

  // Meeting info card (times/place on the left, roles on the right)
  let info(label, value) = [#text(weight: "bold")[#label: ]#value]
  grid(
    columns: (1fr, 1fr),
    column-gutter: 12pt,
    [
      #info("Inizio", start-time) \
      #info("Fine", end-time) \
      #info("Luogo", place)
    ],
    [
      #info("Primary Facilitator", facilitator) \
      #info("Timekeeper", timekeeper) \
      #info("Minute Taker", minute-taker)
    ]
  )

  // Minuta only: attendees
  if extended [
    #v(0.6em)
    #block[
      #info("Presenti", if present.len() > 0 { present.join(", ") } else { "-" }) \
      #info("Assenti", if absent.len() > 0 { absent.join(", ") } else { "-" })
    ]
  ]

  v(0.6em)

  body
}

// The agenda shows the planned meeting: facts only, no outcomes.
#let agenda-template(..args) = meeting-core(kind: "agenda", ..args)

// The minuta reports the meeting: it additionally renders the attendees card
// (present/absent parameters).
#let minuta-template(..args) = meeting-core(kind: "minuta", ..args)
