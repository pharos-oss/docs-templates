// =============================================================================
// TEMPLATE - document layout (cover, header/footer, styles)
// Corso di Gestione dei Progetti Software - Università degli Studi di Salerno
// =============================================================================
// Reusable utilities (palette, callout-box, ...) live in common.typ.
// Usage example, from <document>/main.typ:
//
//   #import "../template.typ": doc-template
//   #show: doc-template.with(title: "...", metadata: (...), revision-history: (...))
//   #include "sections/<section>.typ"
//
// NOTE: image paths written in this file resolve relative to the project root;
// when compiling from the CLI, use `typst compile --root . <document>/main.typ`.
// =============================================================================
#import "common.typ": palette-primary, palette-secondary, palette-tertiary, readable-text, latest-version, table-style

#let doc-template(
  title: "",
  doc-type: "",
  reference: "",
  // Cover metadata table: a tuple of (label, value) pairs, one table row per
  // pair, rendered in order with the label in bold. Values may be strings or
  // any Typst content. Pass an empty tuple () to omit the table entirely.
  //
  // The "Versione" row is optional: if metadata does not include one, the
  // template appends it with the version of the last revision-history entry,
  // so the cover and the footer can never drift apart. To pin the version by
  // hand, add ("Versione", "0.3") to metadata and that value wins.
  //
  // Example:
  //
  //   metadata: (
  //     ("Riferimento", "SOW_Pharos"),
  //     ("Data", "05/10/2026"),
  //     ("Destinatario", "Stakeholder di progetto"),
  //     ("Presentato da", "M. Rossi, L. Verdi"),
  //     ("Approvato da", ""),
  //   ),
  //
  // renders as, with a revision history ending at version 0.3:
  //
  //   | Riferimento   | SOW_Pharos           |
  //   | Data          | 05/10/2026           |
  //   | Destinatario  | Stakeholder di progetto |
  //   | Presentato da | M. Rossi, L. Verdi   |
  //   | Approvato da  |                      |
  //   | Versione      | 0.3                  |
  //
  metadata: (),
  // Tuple of (date, version, description, authors) rows. The version of the
  // last entry is the document version shown in the footer (see
  // latest-version in common.typ), so the two can never drift apart.
  revision-history: (),
  primary-color: palette-primary,
  secondary-color: palette-secondary,
  tertiary-color: palette-tertiary,
  // Logo in the header (left) and brand logo in header + cover (right).
  // Pass `none` to omit them.
  institution-logo: "assets/logo_unisa.png",
  brand-logo: "assets/logo_pharos.png",
  cover-logo-height: 10cm,
  header-line-1: [Laurea Magistrale in Informatica - Università di Salerno],
  header-line-2: [Corso di Gestione dei Progetti Software - Prof.ssa F. Ferrucci e Prof. F. Palomba],
  body
) = {
  // Page Configuration
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 2.5cm, bottom: 2.5cm),
    header: context {
      v(20pt)
      grid(
        columns: (auto, 1fr, auto),
        column-gutter: 12pt,
        align(horizon)[#if institution-logo != none { image(institution-logo, height: 1.15cm) }],
        align(horizon)[
          #text(font: "Liberation Sans", size: 9pt, weight: "bold")[#header-line-1] \
          #text(font: "Liberation Sans", size: 8.5pt, style: "italic", fill: rgb("#333333"))[#header-line-2]
        ],
        align(horizon)[#if brand-logo != none { image(brand-logo, height: 1.6cm) }]
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
          align(left)[#text(tracking: 0.8pt)[#reference V#latest-version(revision-history)]],
          align(right)[Pag. #counter(page).display("1 | 1", both: true)]
        )
      ]
    }
  )

  // Typography & Paragraphs
  set text(font: "Liberation Sans", size: 10pt, lang: "it")
  set par(justify: true, leading: 0.65em)

  // Numbered Sections (1., 2., ...)
  set heading(numbering: "1.")

  // Headings Styling
  show heading.where(level: 1): it => block(above: 1.5em, below: 1em)[
    #set text(weight: "bold", fill: primary-color, size: 15pt)
    #numbering(it.numbering, ..counter(heading).at(it.location())) #it.body
    #v(2pt)
    #line(length: 100%, stroke: 1.2pt + primary-color)
  ]

  show heading.where(level: 2): it => block(above: 1.2em, below: 0.8em)[
    #set text(weight: "bold", fill: secondary-color, size: 12.5pt)
    #it.body
  ]

  show heading.where(level: 3): it => block(above: 0.9em, below: 0.6em)[
    #set text(weight: "bold", fill: tertiary-color, size: 10pt)
    #it.body
    #v(2pt)
  ]

  // Cover: brand logo, document type and title
  block(width: 100%)[
    #set par(justify: false)
    #set text(hyphenate: false)
    #align(center)[
      #if brand-logo != none [#align(center)[#image(brand-logo, height: cover-logo-height)]#v(10pt)]
      #text(size: 42pt, weight: "bold", fill: primary-color)[#doc-type] \
      #v(6pt)
      #text(size: 42pt, weight: "medium", fill: rgb("#333333"))[#title]
    ]
  ]

  // Space between the title and the metadata table (table sits lower on the page)
  v(3.2cm)

  // Metadata Table Block (label | value, one field per horizontal row)
  if metadata.len() > 0 {
    // Append the "Versione" row when metadata omits it: it shows the version
    // of the last revision-history entry, exactly like the footer.
    let has-version = metadata.any(row => row.at(0, default: none) == "Versione")
    let rows = if has-version { metadata } else {
      metadata + (("Versione", latest-version(revision-history)),)
    }
    block[
      #set par(justify: false)
      #set text(hyphenate: false)
      #table(
        columns: (1.3fr, 4fr),
        fill: (x, y) => if x == 0 { rgb("#f4f6f9") } else { none },
        stroke: 0.5pt + rgb("#d0d7de"),
        inset: 7pt,
        align: (x, y) => (left + horizon),
        ..rows.map(((label, value)) => (text(weight: "bold")[#label], value)).flatten()
      )
    ]
  }

  v(0.8em)

  // Revision History Table
  if revision-history.len() > 0 {
    pagebreak()
    heading(level: 2)[#text(size: 15pt)[Revision History]]
    let header-fg = readable-text(primary-color)
    block[
      #set par(justify: false)
      #set text(hyphenate: false)
      #table(
      columns: (1fr, 0.8fr, 3.2fr, 1.5fr),
      ..table-style(primary-color),
      inset: 6pt,
      align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
      table.header(
        ..("Data", "Versione", "Descrizione", "Autori").map(h => text(fill: header-fg)[*#h*])
      ),
      ..revision-history.map(row => row.map(cell => {
        if type(cell) == str { text(fill: if cell == "" { rgb("#888888") } else { rgb("#222222") })[#cell] } else { cell }
      })).flatten()
      )
    ]
  }

  v(1em)

  body
}
