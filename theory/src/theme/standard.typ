// Default theory style: the shared lesson palette and Libertinus Sans typography.
#import "../../../theme.typ" as parent
#let ink = parent.dark
#let accent = parent.primary
#let gray = parent.muted
#let paper = rgb("F7FAFC")
#let sky-blue = rgb("DFEAFB")
#let warm-amber = rgb("E8EFF4")
#let node-fill = sky-blue
#let radius = 0pt

// All semantic roles use the same accent; labels carry their meaning.
#let api = accent
#let security = accent
#let integration = accent
#let deployment = accent
#let success = accent
#let warning = accent
#let danger = accent
#let api-fill = sky-blue
#let security-fill = warm-amber
#let deployment-fill = warm-amber
#let workflow-fill = warm-amber
#let clinical-data-fill = sky-blue

#let presentation(body) = {
  set document(title: "eCREAM — System Architecture and Deployment", author: "Matteo Girardi")
  set text(font: "Libertinus Sans", fill: ink, size: 26pt, hyphenate: false)
  set par(spacing: 0pt, leading: 0.3em)
  set block(spacing: 0pt)
  set grid(align: left + top)
  set raw(theme: none)
  body
}

// Shared content uses a 32 × 18 cm coordinate system, scaled to the parent canvas.
#let frame(body) = page(width: 16cm, height: 9cm, margin: 0pt, fill: paper,
  numbering: none, footer: none, header: none)[
  #set text(font: "Libertinus Sans", fill: ink, hyphenate: false)
  #set par(spacing: 0pt, leading: 0.3em)
  #set block(spacing: 0pt)
  #set grid(align: left + top)
  #set raw(theme: none)
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
  #place(top + left, dx: 664pt, dy: 0pt, rect(width: 244pt, height: 18cm, fill: api-fill, stroke: none))
  #place(top + left, dx: 51pt, dy: 128pt, text(size: 102pt, weight: "bold")[#title])
  #place(top + left, dx: 51pt, dy: 267pt, text(size: 42pt, weight: "bold")[#subtitle])
  #place(top + left, dx: 51pt, dy: 392pt, line(length: 102pt, stroke: 3.6pt + accent))
])

#let slide(title, body, source: none, topic: "architecture", note: none) = {
  let tone = (architecture: accent, api: api, security: security, integration: integration, deployment: deployment).at(topic)
  frame([
    #place(top + left, dx: 51pt, dy: 8pt, text(size: 18pt, weight: "bold", fill: accent)[e-CREAM / Theory])
    #place(top + left, dx: 51pt, dy: 40pt,
      box(width: 805pt)[#text(size: 38pt, weight: "bold", fill: ink)[#title]],
    )
    #place(top + left, dx: 51pt, dy: 98pt, line(length: 102pt, stroke: 3.6pt + tone))
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
