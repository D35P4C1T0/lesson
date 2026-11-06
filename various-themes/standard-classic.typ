// The parent theme's palette, typography and blue underline on its 16 × 9 cm canvas.
#import "../theme.typ" as parent
#let ink = parent.dark
#let accent = parent.primary
#let gray = parent.muted
#let paper = rgb("F7FAFC")
#let node-fill = paper
#let radius = 0pt

#let presentation(body) = {
  set document(title: "eCREAM — System Architecture and Deployment", author: "Matteo Girardi")
  set text(font: ("Libertinus Sans", "Libertinus Serif"), fill: ink, size: 26pt, hyphenate: false)
  set par(spacing: 0pt, leading: 0.3em)
  set block(spacing: 0pt)
  set grid(align: left + top)
  body
}

// Shared content uses a 32 × 18 cm coordinate system, scaled to the parent canvas.
#let frame(body) = page(width: 16cm, height: 9cm, margin: 0pt, fill: paper,
  numbering: none, footer: none, header: none)[
  #set text(font: ("Libertinus Sans", "Libertinus Serif"), fill: ink, hyphenate: false)
  #set par(spacing: 0pt, leading: 0.3em)
  #set block(spacing: 0pt)
  #set grid(align: left + top)
  #scale(x: 50%, y: 50%, reflow: true)[
    #block(width: 32cm, height: 18cm, breakable: false)[
      #body
      #place(top + left, dx: 830pt, dy: 476pt,
        text(size: 18pt)[#context counter(page).display(n => if n < 10 { "0" + str(n) } else { str(n) })],
      )
    ]
  ]
]

#let cover(title, subtitle, course) = frame([
  #place(top + left, dx: 51pt, dy: 50pt, text(size: 27pt, fill: accent)[#course])
  #place(top + left, dx: 51pt, dy: 128pt, text(size: 102pt, weight: "bold")[#title])
  #place(top + left, dx: 51pt, dy: 267pt, text(size: 42pt, weight: "bold")[#subtitle])
  #place(top + left, dx: 51pt, dy: 392pt, line(length: 102pt, stroke: 3.6pt + accent))
])

#let slide(title, body, source: none, note: none, topic: "architecture") = frame([
  #place(top + left, dx: 51pt, dy: 31pt,
    box(width: 805pt)[#text(size: 42pt, weight: "bold")[#title]],
  )
  #place(top + left, dx: 51pt, dy: 89pt, line(length: 102pt, stroke: 3.6pt + accent))
  #place(top + left, dx: 51pt, dy: 110pt,
    block(width: 805pt, height: 350pt)[
      #set text(size: 26pt)
      #align(horizon)[#body]
    ],
  )
  #if note != none {
    place(top + left, dx: 51pt, dy: 476pt,
      box(width: 750pt)[#text(size: 14pt, fill: gray)[#note]],
    )
  }
])
