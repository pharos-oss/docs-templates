// =============================================================================
// COMMON - shared utilities used by every document
// Corso di Gestione dei Progetti Software - Università degli Studi di Salerno
// =============================================================================
// Reusable palette, components and helpers. This file defines no layout:
// that lives in template.typ (doc-template).
// =============================================================================

// =============================================================================
// PALETTE - customize the document colors here
// =============================================================================
#let palette-primary = rgb("#8e7de4")    // violet - main accent
#let palette-secondary = rgb("#6b5eab")  // darker variant of the primary
#let palette-tertiary = rgb("#ba575c")   // rose - secondary accent

// Picks an accessible text color for content drawn on background `bg`:
// white if the background is dark enough, near-black otherwise.
// Based on WCAG relative luminance and contrast ratio.
#let readable-text(bg) = {
  let hex = bg.to-hex().slice(1)
  let chan(i) = int(hex.slice(2 * i, 2 * i + 2), base: 16) / 255
  let lin(c) = if c <= 0.03928 { c / 12.92 } else { calc.pow((c + 0.055) / 1.055, 2.4) }
  let l = 0.2126 * lin(chan(0)) + 0.7152 * lin(chan(1)) + 0.0722 * lin(chan(2))
  let white-contrast = 1.05 / (l + 0.05)
  let dark-contrast = (l + 0.05) / 0.066 // near-black #222222 (luminance ~0.016)
  if white-contrast >= dark-contrast { rgb("#ffffff") } else { rgb("#222222") }
}

// Latest version recorded in a revision history, i.e. the version of its last
// entry. Revision histories are tuples of (date, version, description, authors)
// rows, as accepted by doc-template. Returns "0.1" for an empty history.
#let latest-version(revision-history) = {
  if revision-history.len() == 0 { "0.1" } else { revision-history.last().at(1) }
}

// Custom Callout Component
#let callout-box(title: "", body, border-color: palette-primary, bg-color: rgb("#f4f6f9")) = {
  block(
    fill: bg-color,
    stroke: (left: 4pt + border-color),
    inset: 10pt,
    radius: (right: 4pt),
    width: 100%,
    [
      #text(weight: "bold", fill: border-color)[#title] \
      #v(3pt)
      #body
    ]
  )
}

// Admonitions: callout-box presets with an Italian default title. Usage:
//   #info[...], #warn[...], #danger[...]
// Pass `title:` to override the default label.

// Note or suggestion (the same blue used by the SOW "Nota" callouts).
#let info(body, title: "Nota") = callout-box(
  title: title,
  body,
  border-color: rgb("#0077b6"),
  bg-color: rgb("#caf0f8"),
)

// Something the reader must pay attention to.
#let warn(body, title: "Avviso") = callout-box(
  title: title,
  body,
  border-color: rgb("#b26a00"),
  bg-color: rgb("#fdf0dc"),
)

// A real risk or blocker; uses the rose of the brand palette.
#let danger(body, title: "Pericolo") = callout-box(
  title: title,
  body,
  border-color: palette-tertiary,
  bg-color: rgb("#f9ecec"),
)

// Shared style for data tables (revision history, tasks, action items):
// primary-colored header row (combine with readable-text for the header
// cells), zebra striping on even rows and a light stroke. Use as
// `table(..table-style(primary-color), ...)`.
#let table-style(primary-color) = (
  stroke: 0.5pt + rgb("#d0d7de"),
  fill: (x, y) => if y == 0 { primary-color } else if calc.even(y) { rgb("#f8f9fa") } else { none },
)
