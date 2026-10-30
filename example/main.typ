// =============================================================================
// MAIN - standard document built with doc-template.
// Example document: copy this folder to start a real one (e.g. docs/example/).
// CLI: typst compile --root . example/main.typ
// =============================================================================
#import "../template.typ": doc-template
#import "../common.typ": info, warn, danger, table-style, readable-text, palette-primary
// Once copied into the docs repository, adjust the two imports above to the new
// location: with the submodule in `docs/templates/` and the document in
// `docs/example/`, they become:
//
//   #import "../templates/template.typ": doc-template
//   #import "../templates/common.typ": info, warn, danger, table-style, readable-text, palette-primary

// Cover metadata: one row per (label, value) pair; () omits the table.
// No "Versione" row: the template adds it from the last revision-history entry.
#let metadata = (
  ("Riferimento", "DOC_Pharos"),
  ("Data", "10/11/2026"),
  ("Destinatario", "Stakeholder di progetto"),
  ("Presentato da", "M. Rossi, L. Verdi"),
  ("Approvato da", ""),
)

// One row per change: (date, version, description, authors).
// The last row's version is the one shown in the footer.
#let revision-history = (
  ("08/11/2026", "0.1", "Bozza iniziale", "M. Rossi"),
  ("10/11/2026", "0.2", "Aggiunte le sezioni di stato e dei rischi", "M. Rossi, L. Verdi"),
)

#show: doc-template.with(
  title: "Documento di Esempio",
  doc-type: "Stato Avanzamento (SIT)",
  reference: "DOC_Pharos",
  metadata: metadata,
  revision-history: revision-history,
)

= Obiettivo

Breve descrizione dello scopo del documento. Le sezioni sono scritte a mano con
la markup di Typst e si numerano da sole.

#info[Una nota o un suggerimento per il lettore.]

= Stato avanzamento

== Attività pianificate

#table(
  columns: (2fr, 1.2fr, 1.4fr, 1fr),
  ..table-style(palette-primary),
  inset: 6pt,
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  table.header(
    ..("Attività", "Responsabile", "Scadenza", "Stato").map(h => text(fill: readable-text(palette-primary))[*#h*])
  ),
  [Rubrica di primo contatto], [M. Rossi], [17/11/2026], [In corso],
  [Meccanismo di antipanico], [L. Verdi], [24/11/2026], [In corso],
)

#pagebreak()

= Rischi

#warn[Un rischio o un avviso da non ignorare.]

#danger[Un blocco concreto che richiede un'azione immediata.]

= Conclusioni

Sintesi e prossimi passi.
