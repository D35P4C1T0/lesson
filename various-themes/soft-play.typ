// Self-contained Soft Play theme for the shared eCREAM slides.
#let hc-colors = (
  canvas: rgb("#FAF8F3"),  // warm ivory
  white: rgb("#FFFFFF"),
  ink: rgb("#243D38"),     // dark green-black
  forest: rgb("#315D53"),  // primary identity
  sage: rgb("#B7D9CA"),
  mist: rgb("#E6F1E9"),
  muted: rgb("#607A71"),
  rule: rgb("#D2E2D8"),
  clay: rgb("#EE9B85"),   // small, warm accents
  sand: rgb("#F5E8D1"),
  lilac: rgb("#DDD5ED"),   // supportive playful accent
  butter: rgb("#F6D782"),  // sparing sunny accent
)

#let hc-width = 960pt
#let hc-height = 540pt

#let hc-at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let hc-frame(body, bg: hc-colors.canvas) = page(
  width: hc-width,
  height: hc-height,
  margin: 0pt,
  fill: bg,
  [
    #set text(font: ("Nunito Sans", "Inter"), size: 19pt, fill: hc-colors.ink)
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

#let hc-rule(width: 100%, tone: hc-colors.rule) = line(
  length: width,
  stroke: 1pt + tone,
)
#let ink = hc-colors.ink
#let accent = hc-colors.forest
#let gray = hc-colors.muted
#let paper = hc-colors.canvas
#let node-fill = hc-colors.mist
#let radius = 24pt
#let api = accent
#let security = accent
#let integration = accent
#let deployment = accent
#let success = accent
#let warning = rgb("805A13")
#let danger = rgb("A74931")
#let api-fill = hc-colors.sage
#let security-fill = hc-colors.sand
#let deployment-fill = hc-colors.sand
#let workflow-fill = hc-colors.sand
#let clinical-data-fill = hc-colors.mist
#let fonts = ("Nunito Sans", "Inter", "DejaVu Sans")

#let presentation(body) = {
  set document(title: "eCREAM — System Architecture and Deployment", author: "Matteo Girardi")
  body
}

#let frame(body) = hc-frame([
  #set text(font: fonts, fill: ink, size: 26pt, hyphenate: false)
  #set par(spacing: 0pt, leading: 0.3em)
  #set block(spacing: 0pt)
  #set grid(align: left + top)
  #body
  #hc-at(72pt, 485pt, hc-rule(width: 816pt))
  #hc-at(850pt, 496pt, rect(width: 42pt, height: 30pt, radius: 15pt, fill: node-fill)[
    #align(center + horizon)[#text(size: 16pt, fill: accent)[#context counter(page).display(n => if n < 10 { "0" + str(n) } else { str(n) })]]
  ])
])

#let cover(title, subtitle, course) = frame([
  #hc-at(72pt, 54pt, text(size: 27pt, fill: accent)[#course])
  #hc-at(695pt, 116pt, rect(width: 195pt, height: 295pt, radius: 93pt, fill: node-fill))
  #hc-at(731pt, 146pt, circle(width: 204pt, fill: hc-colors.sage))
  #hc-at(775pt, 190pt, circle(width: 116pt, fill: paper))
  #hc-at(840pt, 245pt, circle(width: 24pt, fill: hc-colors.clay))
  #hc-at(719pt, 358pt, rect(width: 102pt, height: 32pt, radius: 16pt, fill: hc-colors.butter))
  #hc-at(72pt, 145pt, text(size: 92pt, weight: 800)[#title])
  #hc-at(76pt, 318pt, text(size: 38pt, weight: 750)[#subtitle])
])

#let slide(title, body, source: none, topic: "architecture", note: none) = frame([
  #hc-at(72pt, 40pt, box(width: 744pt)[#text(size: 38pt, weight: 750)[#title]])
  #hc-at(836pt, 57pt, circle(width: 12pt, fill: hc-colors.sage))
  #hc-at(854pt, 57pt, circle(width: 12pt, fill: hc-colors.clay))
  #hc-at(872pt, 57pt, circle(width: 12pt, fill: hc-colors.butter))
  #hc-at(72pt, 109pt, hc-rule(width: 816pt))
  #hc-at(72pt, 128pt, block(width: 805pt, height: 350pt)[#align(horizon)[#body]])
  #if note != none {
    hc-at(72pt, 501pt, box(width: 750pt)[#text(size: 14pt, fill: gray)[#note]])
  }
])
