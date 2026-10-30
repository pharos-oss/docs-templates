# Pharos Docs Templates

Template Typst condivisi per i documenti del progetto C09 Pharos del corso di
"Gestione dei Progetti Software, a.a. 2026/27". Contengono solo i template: i
documenti effettivi vivono nel repository che li include come submodule.

## Prerequisiti

- [Typst](https://typst.app/open-source/#download), versione 0.15.1 o successiva.
- [Tinymist](https://myriad-dreamin.github.io/tinymist/#label-Installation), versione 0.15.8 o successiva.
- Il font Liberation Sans (nei sistemi Debian e Ubuntu si installa con il pacchetto `fonts-liberation`).
- Un editor compatibile. Il progetto è stato scritto e provato con Texpile.

## Aggiunta come submodule

Dal repository dei documenti:

```sh
git lfs install
git submodule add https://github.com/pharos-oss/docs-templates docs/templates
git submodule update --init
```

`git lfs install` serve perché i loghi in `assets/` sono gestiti da Git LFS.

## Struttura

```
docs/templates/
├── common.typ            # palette, callout, stile tabelle
├── template.typ          # doc-template: layout dei documenti formali
├── assets/               # loghi (logo_unisa.png, logo_pharos.png, via Git LFS)
├── example/              # esempio di documento standard (main.typ)
└── meeting/
    ├── template.typ      # agenda-template, minuta-template, tabelle
    ├── meeting-data.typ  # task(), action-item(), by-id(), is-closed()
    └── example/          # esempio di meeting (agenda.typ, minuta.typ)
```

## Esempi

Gli esempi compilano senza modifiche: parti da lì per crearne uno tuo. I
comandi vanno eseguiti dentro `docs/templates/`, cioè la cartella del submodule.

```sh
typst compile --root . example/main.typ            # documento standard
typst compile --root . meeting/example/agenda.typ  # agenda
typst compile --root . meeting/example/minuta.typ  # minuta
```

Dopo la copia, aggiorna gli import: quelli verso `agenda.typ` restano uguali,
mentre quelli verso i template vanno ricalcolati rispetto alla posizione finale.
Nel caso standard — submodule `docs/templates/`, documento formale in
`docs/example/`, meeting in `docs/meetings/DATA_MEETING/` — diventano:

```typst
// docs/example/main.typ
#import "../templates/template.typ": doc-template
#import "../templates/common.typ": info, warn, danger, table-style, readable-text, palette-primary

// docs/meetings/DATA_MEETING/agenda.typ
#import "../../templates/meeting/template.typ": agenda-template, task-table, ai-table
#import "../../templates/meeting/meeting-data.typ": task, action-item
```

La regola: conta quanti `../` servono per risalire alla cartella che contiene
`templates/` (con il submodule in `docs/templates/`, è `docs/`), poi scendi in
`templates/`. Uno `../` basta per un file dentro `docs/`, come negli snippet del
*Documento formale*. Gli stessi path sono annotati accanto agli import in
ciascun esempio.

## Documento formale

Dal file `docs/<sezione>/main.typ` del repository documentale. Esempio completo
commentato: `docs/templates/example/main.typ`.

```typst
#import "../templates/template.typ": doc-template

#show: doc-template.with(
  title: "Progetto Pharos",
  doc-type: "Statement of Work (SOW)",
  reference: "SOW_Pharos",
  metadata: (
    ("Riferimento", "SOW_Pharos"),
    ("Versione", "0.3"),
    ("Data", "05/10/2026"),
    ("Destinatario", "Stakeholder di progetto"),
  ),
  revision-history: (
    ("04/10/2026", "0.1", "Draft preliminare", ""),
  ),
)

= Prima sezione
Contenuto del documento.
```

`metadata` è una lista di coppie etichetta/valore: ogni coppia è una riga della
tabella in copertina (tuple vuota `()` per non mostrarla). Non specificare la
riga `Versione`: se manca, il template la aggiunge in fondo con l'ultima
versione della `revision-history`, identica al footer. Per forzarne una
diversa, aggiungi `("Versione", "x.x")` e quel valore vince.
`revision-history` è una lista di righe (data, versione, descrizione, autori):
se la lista è vuota la tabella non compare.

Si compila dalla root del repository con `--root .`, perché i file importano
immagini e altri file fuori dalla loro cartella:

```sh
typst compile --root . docs/sow/main.typ
```

Gli editor come Texpile configurano la root in automatico, quindi da lì puoi
compilare senza flag.

## Meeting

Un meeting è una cartella dentro `docs/meetings/` del repository documentale,
con due file: `agenda.typ` (i fatti pianificati) e `minuta.typ` (ciò che è
successo). L'esempio completo commentato è in `docs/templates/meeting/example/`.

### Agenda

```typst
#import "../../templates/meeting/template.typ": agenda-template, task-table, ai-table
#import "../../templates/meeting/meeting-data.typ": task, action-item, by-id

#show: agenda-template.with(project: "Pharos", number: 1, date: "10/11/2026")

= Obiettivo (tempo allocato: 10 minuti)
...
= Status (tempo allocato: 20 minuti)
== Attività pianificate
#task-table(tasks)
== Action items
#ai-table(action-items)
```

La numerazione delle sezioni arriva in automatico; il numero del meeting
compare come sottotitolo. L'agenda mostra solo le action item ancora aperte:
per vederle tutte, `#ai-table(action-items, hide-closed: false)`.

### Minuta

La minuta sta accanto all'agenda e importa i fatti con una riga sola, poi
dichiara solo le differenze:

```typst
#import "agenda.typ": *
#import "../../templates/meeting/template.typ": minuta-template, ai-table

#let ai-1 = by-id(action-items, "AI1") + (status: "Chiusa", closed: "10/11/2026")
#let updated-action-items = (ai-1, ai-2, ai-3)

#show: minuta-template.with(
  project: "Pharos", number: 1, date: "10/11/2026",
  present: present, absent: absent,
)
```

Usa sempre `by-id(items, "AI1")` per cercare un elemento: se l'identificativo
non esiste la compilazione fallisce con un messaggio chiaro invece di
mostrare la riga sbagliata.

La sezione iniziale `Action items` mostra la tabella come arrivata dal meeting
precedente: `#ai-table(action-items, hide-closed: false)`. Quella del wrap up
mostra la situazione aggiornata con tutte le colonne: `#ai-table(updated-action-items, extended: true)`.
È quella che il meeting successivo erediterà:
```typst
#import "../2026-11-03/minuta.typ": updated-action-items as action-items
```

### Tabelle e paginazione

- `task-table(tasks)`: attività pianificate.
- `ai-table(items, extended: false, hide-closed: none)`: `extended: true` aggiunge
  tutte le colonne; `hide-closed` (`true`/`false`) forza la visibilità degli item
  completati (status `"Chiusa"` o data di chiusura, vedi `is-closed`).
- Entrambe accettano `primary-color`.
- Le interruzioni di pagina non si ereditano fra agenda e minuta: scrivi
  `#pagebreak()` nel file che ti interessa, `#pagebreak(weak: true)` se temi
  pagine bianche.

## Componenti disponibili

- `common.typ`: `palette-primary/secondary/tertiary`, `readable-text`,
  `latest-version`, `table-style`, `callout-box` e i preset `info`, `warn`,
  `danger` (accettano `title`).
- `template.typ`: `doc-template` (copertina, header/footer, revision history).
  Parametri utili: `institution-logo`, `brand-logo`, `cover-logo-height`,
  `header-line-1`, `header-line-2`.
- `meeting/template.typ`: `agenda-template`, `minuta-template`, `task-table`,
  `ai-table`.
- `meeting/meeting-data.typ`: `task`, `action-item`, `is-closed`, `by-id`.

## Personalizzazione

I colori si cambiano in `common.typ` (palette) o passando `primary-color`,
`secondary-color` e `tertiary-color` a `doc-template`. Loghi e righe
dell'header si sovrascrivono con i parametri elencati sopra.
