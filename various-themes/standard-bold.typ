// The parent theme's palette, typography and blue underline on its 16 × 9 cm canvas.
#import "../theme.typ" as parent
#let ink = parent.dark
#let accent = parent.primary
#let gray = parent.muted
#let paper = rgb("F7FAFC")
#let node-fill = paper
#let radius = 0pt

#let api = rgb("007E87")
#let security = rgb("A6573B")
#let integration = security
#let deployment = rgb("67498F")
#let success = rgb("16704B")
#let warning = rgb("956010")
#let danger = rgb("B4323C")
#let api-fill = rgb("DFEAFB")
#let security-fill = rgb("F6DFD4")
#let deployment-fill = rgb("EAE0F5")

#let presentation(body) = {
  set document(title: "eCREAM — System Architecture and Deployment", author: "Matteo Girardi")
  set text(font: ("Libertinus Sans", "Libertinus Serif"), fill: ink, size: 26pt, hyphenate: false)
  set par(spacing: 0pt, leading: 0.3em)
  set block(spacing: 0pt)
  set grid(align: left + top)
  body
}

// Shared content uses a 32 × 18 cm coordinate system, scaled to the parent canvas.
#let frame(body, background: paper, dark: false) = page(width: 16cm, height: 9cm, margin: 0pt, fill: background,
  numbering: none, footer: none, header: none)[
  #set text(font: ("Libertinus Sans", "Libertinus Serif"), fill: if dark { white } else { ink }, hyphenate: false)
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
  #place(top + left, dx: 51pt, dy: 50pt, text(size: 27pt, fill: white)[#course])
  #place(top + left, dx: 664pt, dy: 0pt, rect(width: 244pt, height: 18cm, fill: accent, stroke: none))
  #place(top + left, dx: 51pt, dy: 128pt, text(size: 102pt, weight: "bold")[#title])
  #place(top + left, dx: 51pt, dy: 267pt, text(size: 42pt, weight: "bold")[#subtitle])
  #place(top + left, dx: 51pt, dy: 392pt, line(length: 102pt, stroke: 3.6pt + white))
], background: ink, dark: true)

#let slide(title, body, source: none, topic: "architecture", note: none) = {
  let tone = (architecture: accent, api: api, security: security, integration: integration, deployment: deployment).at(topic)
  frame([
    #place(top + left, rect(width: 32cm, height: 102pt, fill: tone, stroke: none))
    #place(top + left, dx: 51pt, dy: 31pt,
      box(width: 805pt)[#text(size: 42pt, weight: "bold", fill: white)[#title]],
    )
    #place(top + left, dx: 51pt, dy: 89pt, line(length: 102pt, stroke: 3.6pt + white))
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
}
