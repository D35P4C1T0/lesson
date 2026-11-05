// Punto di ingresso comune della presentazione.
// Ogni sezione è mantenuta in un file separato per ridurre i conflitti Git.
#import "theme.typ": cover, slide

#set document(title: "e-CREAM — Presentazione", author: "Gruppo e-CREAM")
#set page(
  width: 16cm,
  height: 9cm,
  margin: (x: 1.15cm, y: 0.9cm),
  fill: rgb("F7FAFC"),
  numbering: "1",
  number-align: right,
)
#set text(font: "Libertinus Sans", size: 18pt, fill: rgb("172A3A"))
#set par(leading: 0.5em)

#cover(
  "e-CREAM",
  "Presentazione del progetto e attività pratiche",
  "Gruppo di lavoro — 5 studenti",
)

#slide("Introduzione", "Programma della lezione")[
  - *Theory* — introduzione e concetti fondamentali
  - *Ex 1* — primo esercizio
  - *Ex 2* — secondo esercizio
  - *Ex 3* — terzo esercizio
  - *Ex 4* — quarto esercizio
]

// Sezioni: in genere ciascuno modifica soltanto il file assegnato.
#include "theory/slides.typ"
#include "ex1/slides.typ"
#include "ex2/slides.typ"
#include "ex3/slides.typ"
#include "ex4/slides.typ"

#slide("Conclusione", "Domande?")[
  Riepilogo e discussione finale.
]
