// Swiss / International Typographic Style: a fixed grid and one accent.
#let ink = rgb("171717")
#let accent = rgb("E63323")
#let paper = rgb("FAF9F6")
#let gray = rgb("626262")

#let presentation(body) = {
  set document(title: "eCREAM — Architecture and Deployment", author: "Matteo Girardi")
  set page(
    width: 32cm, height: 18cm,
    margin: (left: 1.8cm, right: 1.8cm, top: 1.1cm, bottom: 1.2cm),
    fill: paper,
    footer: context [
      #align(right)[#text(size: 18pt, fill: ink, weight: "bold", counter(page).display(n => if n < 10 { "0" + str(n) } else { str(n) }))]
    ],
  )
  set text(font: ("Helvetica Neue", "Helvetica", "Arial", "Liberation Sans", "DejaVu Sans"), size: 26pt, fill: ink)
  set par(spacing: 0pt, leading: 0.3em)
  set block(spacing: 0pt)
  set grid(align: left + top)
  show strong: set text(weight: "bold")
  body
}

#let cover(title, subtitle, course) = [
  #pagebreak(weak: true)
  #block[#text(size: 27pt, fill: accent)[#course]]
  #v(75pt)
  #block[#text(size: 102pt, weight: "bold", tracking: -2pt)[#title]]
  #v(24pt)
  #block[#text(size: 42pt, weight: "bold")[#subtitle]]
]

// Fixed title and content tracks; source references stay in the slide source.
#let slide(title, body, source: [eCREAM D3.2 · Architectural Design · 29 November 2024], note: none) = [
  #set page(footer: context [
    #grid(columns: (1fr, auto), gutter: 24pt, align: bottom,
      text(size: 13pt, fill: gray)[#if note != none { note }],
      text(size: 18pt, fill: ink, weight: "bold", counter(page).display(n => if n < 10 { "0" + str(n) } else { str(n) })),
    )
  ])
  #pagebreak(weak: true)
  #grid(columns: (1fr,), rows: (56pt, 358pt), row-gutter: 16pt,
    text(size: 42pt, weight: "bold", tracking: -0.5pt)[#title],
    block(width: 100%, height: 358pt)[#align(horizon)[#body]],
  )
]

#let node(body, red: false, height: 94pt) = rect(
  width: 100%, height: height, inset: 14pt,
  stroke: (if red { 1.8pt + accent } else { 1pt + ink }),
)[#align(left + horizon)[#text(size: 23pt)[#body]]]
#let arrow = align(center + horizon)[#text(size: 30pt, fill: accent)[→]]
#let down = block(width: 100%, height: 24pt)[#align(center + horizon)[#text(size: 23pt, fill: accent)[↓]]]
#let rule = line(length: 100%, stroke: 0.7pt + gray)
#let small(body) = text(size: 18pt, fill: gray)[#body]
