// Humanist Clinical — a self-contained 16:9 slide system for Typst.
// No third-party packages. Font: Inter / Inter Display (falls back if unavailable).
// Usage: #import "humanist-clinical.typ": *
//        #hc-cover([Your title], [Your subtitle])
//        #hc-slide([Slide title], [Your content])
//
// Design coordinates are in typographic points on a 960 × 540 pt canvas.
// Keep body copy comfortably above ~18 pt when projecting.

#let hc-colors = (
  canvas: rgb("#F7F6F1"),  // warm ivory
  white: rgb("#FFFFFF"),
  ink: rgb("#20332F"),     // dark green-black
  forest: rgb("#264B45"),  // primary identity
  sage: rgb("#9CB8A8"),
  mist: rgb("#E2EBE4"),
  muted: rgb("#647770"),
  rule: rgb("#D1DBD3"),
  clay: rgb("#C77E68"),   // small, warm accents
  sand: rgb("#EBE5D7"),
)

#let hc-width = 960pt
#let hc-height = 540pt

// The helpers below keep geometry, page treatment, and type consistent.
#let hc-at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let hc-frame(body, bg: hc-colors.canvas) = page(
  width: hc-width,
  height: hc-height,
  margin: 0pt,
  fill: bg,
  [
    #set text(font: "Inter", size: 19pt, fill: hc-colors.ink)
    #set par(leading: 1.26em, spacing: 0.45em)
    // A full-size unbreakable block makes every page deterministic,
    // even when the slide itself only contains overlaid elements.
    #block(
      width: hc-width,
      height: hc-height,
      breakable: false,
      inset: 0pt,
      above: 0pt,
      below: 0pt,
    )[#body]
  ],
)

#let hc-kicker(body, on-dark: false) = text(
  font: "Inter",
  size: 11pt,
  weight: 650,
  tracking: 0.9pt,
  fill: if on-dark { hc-colors.sage } else { hc-colors.forest },
  body,
)

#let hc-subtle(body, on-dark: false) = text(
  size: 12pt,
  weight: 450,
  fill: if on-dark { hc-colors.mist } else { hc-colors.muted },
  body,
)

#let hc-lead(body) = text(
  font: "Inter Display",
  size: 27pt,
  weight: 550,
  fill: hc-colors.forest,
  body,
)

#let hc-rule(width: 100%, tone: hc-colors.rule) = line(
  length: width,
  stroke: 1pt + tone,
)

#let hc-chip(body, strong: false) = rect(
  radius: 100pt,
  fill: if strong { hc-colors.forest } else { hc-colors.mist },
  inset: (x: 13pt, y: 7pt),
  text(
    size: 11pt,
    weight: 600,
    fill: if strong { hc-colors.white } else { hc-colors.forest },
    body,
  ),
)

#let hc-panel(body, label: none, bg: hc-colors.mist, height: 220pt) = rect(
  width: 100%,
  height: height,
  radius: 13pt,
  fill: bg,
  inset: 24pt,
  [
    #if label != none {
      [#hc-kicker(label) #v(13pt)]
    }
    #body
  ],
)

#let hc-card(index, title, description) = hc-panel(
  [
    #text(font: "Inter Display", size: 36pt, weight: 550, fill: hc-colors.sage)[#index]
    #v(18pt)
    #text(size: 21pt, weight: 620, fill: hc-colors.ink)[#title]
    #v(10pt)
    #text(size: 15pt, fill: hc-colors.muted)[#description]
  ],
  bg: hc-colors.white,
  height: 225pt,
)

#let hc-metric(value, name, caption) = hc-panel(
  [
    #text(font: "Inter Display", size: 51pt, weight: 580, fill: hc-colors.forest)[#value]
    #v(8pt)
    #text(size: 18pt, weight: 620)[#name]
    #v(11pt)
    #text(size: 13pt, fill: hc-colors.muted)[#caption]
  ],
  bg: hc-colors.white,
  height: 218pt,
)

#let hc-columns(left, right, gap: 24pt) = grid(
  columns: (1fr, 1fr),
  column-gutter: gap,
  left,
  right,
)

#let hc-three(a, b, c, gap: 16pt) = grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: gap,
  a,
  b,
  c,
)

// Internal chrome: unobtrusive footer and identity mark.
#let hc-footer(section: "HUMANIST CLINICAL") = [
  #hc-at(72pt, 480pt, hc-rule(width: 816pt))
  #hc-at(72pt, 493pt, hc-subtle([DESIGN SYSTEM / #section]))
  #hc-at(867pt, 493pt, hc-subtle([#context counter(page).display("1")]))
]

// Slide type 01: title / cover.
#let hc-cover(title, subtitle, overline: "HUMANIST CLINICAL", meta: "A thoughtful approach to visual communication") = hc-frame([
  // Framed geometry provides a gentle clinical cue without a medical cross.
  #hc-at(692pt, 91pt, rect(width: 196pt, height: 295pt, radius: 14pt, fill: hc-colors.mist))
  #hc-at(739pt, 130pt, circle(width: 210pt, height: 210pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(781pt, 171pt, circle(width: 126pt, height: 126pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(836pt, 225pt, circle(width: 19pt, height: 19pt, fill: hc-colors.clay))
  #hc-at(72pt, 54pt, hc-kicker([HC / #overline]))
  #hc-at(72pt, 145pt, box(width: 715pt)[
    #set text(font: "Inter Display", size: 59pt, weight: 620, fill: hc-colors.ink)
    #set par(leading: 0.98em)
    #title
  ])
  #hc-at(76pt, 347pt, box(width: 570pt)[
    #text(size: 21pt, fill: hc-colors.muted)[#subtitle]
  ])
  #hc-at(72pt, 442pt, hc-rule(width: 816pt))
  #hc-at(72pt, 462pt, hc-subtle([#meta]))
  #hc-at(850pt, 462pt, hc-kicker([01 / HC]))
])

// Slide type 02: full-bleed section divider.
#let hc-section(index, title, description: none, label: "SECTION") = hc-frame([
  #hc-at(72pt, 55pt, hc-kicker([#label / #index], on-dark: true))
  #hc-at(72pt, 156pt, box(width: 750pt)[
    #set text(font: "Inter Display", size: 60pt, weight: 600, fill: hc-colors.white)
    #set par(leading: 1.02em)
    #title
  ])
  #if description != none {
    hc-at(74pt, 340pt, box(width: 630pt)[
      #text(size: 19pt, fill: hc-colors.mist)[#description]
    ])
  }
  #hc-at(704pt, 126pt, circle(width: 316pt, height: 316pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(782pt, 205pt, circle(width: 158pt, height: 158pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(72pt, 475pt, hc-rule(width: 816pt, tone: hc-colors.sage))
  #hc-at(72pt, 492pt, hc-subtle([SYSTEM / CLARITY / CARE], on-dark: true))
], bg: hc-colors.forest)

// Slide type 03: most everyday content slides. Body is deliberately flexible:
// use a grid, text, a chart, an image or any other Typst content.
#let hc-slide(title, body, kicker: "OVERVIEW", section: "HUMANIST CLINICAL") = hc-frame([
  #hc-at(72pt, 48pt, hc-kicker(kicker))
  #hc-at(72pt, 87pt, box(width: 816pt)[
    #text(font: "Inter Display", size: 37pt, weight: 600)[#title]
  ])
  #hc-at(72pt, 147pt, hc-rule(width: 816pt))
  #hc-at(72pt, 183pt, box(width: 816pt, height: 278pt)[#body])
  #hc-footer(section: section)
])

// Slide type 04: a quiet editorial quote, for emphasis and transition.
#let hc-quote(quote, source: none, overline: "A CENTRAL IDEA") = hc-frame([
  #hc-at(72pt, 58pt, hc-kicker(overline))
  #hc-at(72pt, 137pt, rect(width: 6pt, height: 232pt, radius: 3pt, fill: hc-colors.clay))
  #hc-at(103pt, 137pt, box(width: 720pt)[
    #set text(font: "Inter Display", size: 42pt, weight: 540, fill: hc-colors.forest)
    #set par(leading: 1.1em)
    #quote
  ])
  #if source != none {
    hc-at(105pt, 395pt, hc-subtle(source))
  }
  #hc-footer(section: "PERSPECTIVE")
])

// Slide type 05: a quiet finish, rather than a giant "THANK YOU" on white.
#let hc-closing(title: [Thank you.], subtitle: [Questions, ideas, and next steps.]) = hc-frame([
  #hc-at(72pt, 56pt, hc-kicker([HUMANIST / CLINICAL], on-dark: true))
  #hc-at(72pt, 180pt, box(width: 690pt)[
    #text(font: "Inter Display", size: 72pt, weight: 590, fill: hc-colors.white)[#title]
  ])
  #hc-at(76pt, 302pt, box(width: 650pt)[
    #text(size: 23pt, fill: hc-colors.mist)[#subtitle]
  ])
  #hc-at(72pt, 462pt, hc-rule(width: 816pt, tone: hc-colors.sage))
  #hc-at(72pt, 482pt, hc-subtle([THE END / KEEP IT HUMAN], on-dark: true))
  #hc-at(758pt, 125pt, circle(width: 150pt, height: 150pt, fill: none, stroke: 3pt + hc-colors.sage))
  #hc-at(805pt, 172pt, circle(width: 56pt, height: 56pt, fill: hc-colors.clay))
], bg: hc-colors.forest)
