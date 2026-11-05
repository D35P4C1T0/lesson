// Demo deck: compile with `typst compile example.typ example.pdf`.
#import "humanist-clinical.typ": *

#hc-cover(
  [Care through #linebreak() clarity.],
  [A warm, rigorous visual language for meaningful ideas.],
  meta: "A style study / Version 1.0",
)

#hc-section(
  "01",
  [The design #linebreak() philosophy],
  description: [Structure creates confidence. Warmth makes information approachable.],
)

#hc-slide(
  [Precision should feel welcoming.],
  [
    #hc-three(
      hc-card([01], [Order], [Clear hierarchy, recurring rhythm, predictable placements.]),
      hc-card([02], [Warmth], [Softer surfaces, generous breathing room, and human language.]),
      hc-card([03], [Trust], [Information first. Decoration only where it adds meaning.]),
    )
  ],
  kicker: "PRINCIPLES / 01",
  section: "FOUNDATIONS",
)

#hc-slide(
  [A palette built around trust.],
  [
    #grid(
      columns: (1fr, 1fr, 1fr, 1fr, 1fr),
      column-gutter: 12pt,
      [#rect(width: 100%, height: 155pt, radius: 10pt, fill: hc-colors.canvas)
       #v(12pt) #text(size: 14pt, weight: 650)[Ivory] #v(4pt)
       #text(size: 12pt, fill: hc-colors.muted)[F7F6F1]],
      [#rect(width: 100%, height: 155pt, radius: 10pt, fill: hc-colors.forest)
       #v(12pt) #text(size: 14pt, weight: 650)[Forest] #v(4pt)
       #text(size: 12pt, fill: hc-colors.muted)[264B45]],
      [#rect(width: 100%, height: 155pt, radius: 10pt, fill: hc-colors.sage)
       #v(12pt) #text(size: 14pt, weight: 650)[Sage] #v(4pt)
       #text(size: 12pt, fill: hc-colors.muted)[9CB8A8]],
      [#rect(width: 100%, height: 155pt, radius: 10pt, fill: hc-colors.mist)
       #v(12pt) #text(size: 14pt, weight: 650)[Mist] #v(4pt)
       #text(size: 12pt, fill: hc-colors.muted)[E2EBE4]],
      [#rect(width: 100%, height: 155pt, radius: 10pt, fill: hc-colors.clay)
       #v(12pt) #text(size: 14pt, weight: 650)[Clay] #v(4pt)
       #text(size: 12pt, fill: hc-colors.muted)[C77E68]],
    )
  ],
  kicker: "IDENTITY / COLORS",
  section: "FOUNDATIONS",
)

#hc-slide(
  [Type should do the hard work.],
  [
    #hc-columns(
      [
        #text(font: "Inter Display", size: 50pt, weight: 620, fill: hc-colors.forest)[Aa]
        #v(8pt)
        #text(size: 24pt, weight: 600)[Inter Display]
        #v(13pt)
        #text(size: 16pt, fill: hc-colors.muted)[Confident headlines. Short lines. Large, deliberate hierarchy.]
      ],
      hc-panel([
        #hc-kicker([BODY / INTER REGULAR])
        #v(18pt)
        #text(size: 20pt, weight: 460)[Good information should be easy to understand, at a glance and from the back of the room.]
        #v(18pt)
        #hc-subtle([Supporting labels / 11–13 pt])
      ], height: 254pt),
    )
  ],
  kicker: "IDENTITY / TYPE",
  section: "FOUNDATIONS",
)

#hc-quote(
  [The human part of healthcare is not the opposite of precision.],
  source: [A guiding principle / Humanist Clinical],
)

#hc-slide(
  [Data with a human scale.],
  [
    #hc-three(
      hc-metric([92%], [Confidence], [Illustrative metric]),
      hc-metric([4.8/5], [Experience], [Illustrative metric]),
      hc-metric([24h], [Response], [Illustrative metric]),
    )
    #v(14pt)
    #hc-subtle([All figures are fictional placeholders, used only to demonstrate layout.])
  ],
  kicker: "COMPONENTS / METRICS",
  section: "COMPONENTS",
)

#hc-slide(
  [Make complexity navigable.],
  [
    #hc-columns(
      [
        #hc-lead([One idea per screen.])
        #v(20pt)
        #text(size: 18pt)[Keep the headline meaningful and the details well-spaced.]
        #v(18pt)
        #hc-chip([Core insight], strong: true)
        #h(8pt)
        #hc-chip([Supporting detail])
      ],
      hc-panel([
        #hc-kicker([A SIMPLE RHYTHM])
        #v(16pt)
        #text(size: 19pt, weight: 600)[01 / Introduce]
        #v(8pt)
        #hc-rule()
        #v(11pt)
        #text(size: 19pt, weight: 600)[02 / Explain]
        #v(8pt)
        #hc-rule()
        #v(11pt)
        #text(size: 19pt, weight: 600)[03 / Conclude]
      ], height: 262pt),
    )
  ],
  kicker: "COMPONENTS / PATTERNS",
  section: "COMPONENTS",
)

#hc-closing()
