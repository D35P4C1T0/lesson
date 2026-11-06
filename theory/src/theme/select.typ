// Shared adapter for the lesson entry point and Python theme builds.
#let adapt(chosen, render: none) = {
  let definitions = dictionary(chosen)
  let ink = definitions.at("ink", default: definitions.at("dark", default: rgb("172A3A")))
  let accent = definitions.at("accent", default: definitions.at("primary", default: rgb("176A96")))
  let paper = definitions.at("paper", default: rgb("F7FAFC"))
  let fill = definitions.at("node-fill", default: paper)
  let fallback-cover(title, subtitle, course) = [
    #text(size: 27pt, fill: accent)[#course]
    #v(50pt)
    #text(size: 92pt, weight: "bold")[#title]
    #v(24pt)
    #text(size: 42pt, weight: "bold")[#subtitle]
  ]
  let defaults = (
    ink: ink, accent: accent, paper: paper,
    gray: definitions.at("muted", default: rgb("596D7E")),
    node-fill: fill, radius: 0pt,
    api: accent, integration: accent, security: accent, deployment: accent,
    success: accent, warning: accent, danger: accent,
    api-fill: fill, security-fill: fill, deployment-fill: fill,
    workflow-fill: fill, clinical-data-fill: fill,
    presentation: body => body, cover: fallback-cover,
  )
  let theme = defaults + definitions
  if render != none { theme += (slide: render,) }
  theme
}

#let select(name) = {
  let path = if name.starts-with("/") {
    name
  } else if name in ("standard", "clinical", "swiss") {
    "/theory/src/theme/" + (if name == "swiss" { "clinical" } else { name }) + ".typ"
  } else {
    "/various-themes/" + name + ".typ"
  }
  import path as chosen
  adapt(chosen)
}
