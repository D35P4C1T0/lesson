// Deck adapter for the supplied Humanist Clinical kit; no demo branding or sources.
#import "../theory/src/theme/humanist-clinical-typst-kit/humanist-clinical.typ": hc-frame, hc-at, hc-rule, hc-colors
#let ink = hc-colors.ink
#let accent = hc-colors.forest
#let gray = hc-colors.muted
#let paper = hc-colors.canvas
#let node-fill = hc-colors.mist
#let radius = 8pt

#let api = rgb("2563AD")
#let security = rgb("A6573B")
#let integration = security
#let deployment = rgb("67498F")
#let success = rgb("16704B")
#let warning = rgb("956010")
#let danger = rgb("B4323C")
#let api-fill = rgb("DFEAFB")
#let security-fill = rgb("F6DFD4")
#let deployment-fill = rgb("EAE0F5")
#let workflow-fill = rgb("FFF0C9")
#let clinical-data-fill = rgb("D6ECDF")
#let fonts = ("Inter", "DejaVu Sans")
#let display-fonts = ("Inter Display", "Inter", "DejaVu Sans")

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
  #hc-at(72pt, 485pt, hc-rule(width: 816pt, tone: hc-colors.rule))
  #hc-at(866pt, 499pt, text(size: 18pt, fill: gray)[#context counter(page).display(n => if n < 10 { "0" + str(n) } else { str(n) })])
])

#let cover(title, subtitle, course) = frame([
  #hc-at(72pt, 54pt, text(size: 27pt, fill: accent)[#course])
  #hc-at(692pt, 116pt, rect(width: 196pt, height: 295pt, radius: 14pt, fill: node-fill))
  #hc-at(739pt, 155pt, circle(width: 210pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(781pt, 197pt, circle(width: 126pt, fill: none, stroke: 2pt + hc-colors.sage))
  #hc-at(835pt, 251pt, circle(width: 30pt, fill: hc-colors.clay))
  #hc-at(72pt, 145pt, text(font: display-fonts, size: 92pt, weight: "bold")[#title])
  #hc-at(76pt, 318pt, text(font: display-fonts, size: 38pt, weight: "bold")[#subtitle])
])

#let slide(title, body, source: none, topic: "architecture", note: none) = {
  let tone = (architecture: accent, api: api, security: security, integration: integration, deployment: deployment).at(topic)
  frame([
    #hc-at(72pt, 40pt, box(width: 816pt)[#text(font: display-fonts, size: 40pt, weight: "bold", fill: ink)[#title]])
    #hc-at(72pt, 109pt, hc-rule(width: 816pt, tone: tone))
    #hc-at(72pt, 128pt, block(width: 805pt, height: 350pt)[#align(horizon)[#body]])
  #if note != none {
    hc-at(72pt, 501pt, box(width: 750pt)[#text(size: 14pt, fill: gray)[#note]])
  }
  ])
}
