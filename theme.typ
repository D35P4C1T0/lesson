// Stile condiviso. Modificarlo solo quando serve uniformare tutte le slide.
#let primary = rgb("176A96")
#let dark = rgb("172A3A")
#let muted = rgb("596D7E")

#let cover(title, subtitle, authors) = [
  #v(1.1cm)
  #text(size: 14pt, weight: "bold", fill: primary)[PRESENTAZIONE DI GRUPPO]
  #v(0.45cm)
  #text(size: 45pt, weight: "bold", fill: dark)[#title]
  #v(0.25cm)
  #text(size: 20pt, fill: muted)[#subtitle]
  #v(1.3cm)
  #text(size: 14pt, fill: muted)[#authors]
]

// Ogni chiamata produce una nuova slide, senza dover inserire pagebreak a mano.
#let slide(section, title, body) = [
  #pagebreak()
  #text(size: 11pt, weight: "bold", fill: primary)[e-CREAM / #section]
  #v(0.25cm)
  #text(size: 29pt, weight: "bold", fill: dark)[#title]
  #v(0.25cm)
  #rect(width: 1.8cm, height: 1.8pt, fill: primary, stroke: none)
  #v(0.45cm)
  #set text(size: 18pt)
  #body
]
