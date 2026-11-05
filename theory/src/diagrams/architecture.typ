// eCREAM D3.2 (29 Nov 2024), pp. 10–22. Logical structure, not deployment units.
// The main path uses the BFF; direct dashboard-to-module access is also allowed.
// Data repositories represent module-owned stores, not a shared database contract.
#let architecture(style) = {
  let ink = style.ink
  let accent = style.accent
  let gray = style.gray
  let paper = style.node-fill
  let box(x, y, w, h, body, highlight: false, tone: accent, fill: paper) = place(top + left, dx: x * 1pt, dy: y * 1pt,
    rect(width: w * 1pt, height: h * 1pt, inset: (x: 15pt, y: if h > 60 { 14pt } else { 10pt }),
      fill: fill, radius: calc.min(style.radius, 12pt),
      stroke: (if highlight { 1.6pt + tone } else { 0.8pt + ink }),
    )[#align(left + horizon)[#text(fill: ink)[#body]]],
  )
  let edge(x1, y1, x2, y2, head: true) = {
    assert(x1 == x2 or y1 == y2, message: "Diagram connectors must be orthogonal")
    place(top + left, dx: calc.min(x1, x2) * 1pt, dy: calc.min(y1, y2) * 1pt,
      line(start: (0pt, 0pt), end: (calc.abs(x2 - x1) * 1pt, calc.abs(y2 - y1) * 1pt), stroke: 1pt + accent),
    )
    if head {
      if x1 == x2 {
        assert(y2 > y1)
        place(top + left, dx: (x2 - 3) * 1pt, dy: (y2 - 5) * 1pt,
          polygon((0pt, 0pt), (6pt, 0pt), (3pt, 5pt), fill: accent, stroke: none),
        )
      } else {
        assert(x2 > x1)
        place(top + left, dx: (x2 - 5) * 1pt, dy: (y2 - 3) * 1pt,
          polygon((0pt, 0pt), (0pt, 6pt), (5pt, 3pt), fill: accent, stroke: none),
        )
      }
    }
  }
  block(width: 805pt, height: 350pt)[
    #set text(size: 16.5pt)
    #set par(leading: 0.32em, spacing: 0pt)

    // Draw connectors behind boxes, with explicit arrowheads at entry points.
    #edge(141, 42, 141, 67)
    #edge(455, 42, 455, 67)
    #edge(717.5, 42, 717.5, 67)
    #edge(298, 109, 298, 126, head: false)
    #edge(717.5, 109, 717.5, 126, head: false)
    #edge(92, 126, 717.5, 126, head: false)
    #edge(92, 126, 92, 143)
    #edge(298, 126, 298, 143)
    #edge(504, 126, 504, 143)
    #edge(717.5, 126, 717.5, 165)
    #edge(92, 259, 92, 310)
    #edge(504, 259, 504, 310)
    #edge(717.5, 259, 717.5, 310)

    #box(0, 0, 282, 42, [*Admin Dashboard*])
    #box(314, 0, 282, 42, [*ER Dashboard*])
    #box(630, 0, 175, 42, [*External clients*])

    #box(0, 67, 596, 42, [*Web API / BFF* · dashboard aggregation], highlight: true)
    #box(630, 67, 175, 42, [*FHIR API*], highlight: true, tone: style.api, fill: style.api-fill)

    #box(0, 143, 184, 116, [
      *Core*\
      Authentication\
      Permissions\
      Settings · Auditing
    ], fill: style.api-fill)
    #box(206, 143, 184, 116, [
      *Workflow*\
      Patient flow\
      Waiting List\
      Reasoner
    ], fill: style.workflow-fill)
    #box(412, 143, 184, 116, [
      *Clinical data*\
      Patient details\
      Clinical records\
      Medications · Diary
    ], fill: style.clinical-data-fill)
    #box(630, 165, 175, 94, [
      *Bridges*\
      Exams · Billing\
      Local adapters
    ], fill: style.security-fill)

    #box(0, 310, 596, 40, [*Data repositories* · PostgreSQL], fill: style.deployment-fill)
    #box(630, 310, 175, 40, [*Hospital systems*])
    #place(top + left, dx: 217pt, dy: 281pt,
      text(size: 14pt, fill: gray)[HTTP / REST-like APIs],
    )
  ]
}
