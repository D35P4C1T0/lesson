# Humanist Clinical — Typst slide stylesheet

A minimalist **16:9 Typst presentation design system** combining Swiss editorial structure with a warmer, more human healthcare sensibility. The visual direction is generic, not linked to any organization or project.

## Files

- `humanist-clinical.typ`: reusable theme and presentation components.
- `example.typ`: nine-slide sample deck with all main components.
- `visual-reference.pdf`: an independently rendered concept preview (not Typst output).

## Quick start

Place `humanist-clinical.typ` beside your deck and start with:

```typst
#import "humanist-clinical.typ": *

#hc-cover(
  [Your presentation title],
  [A short description of what you'll discuss.],
)

#hc-section("01", [A section title])

#hc-slide(
  [A clear, declarative headline],
  [
    #hc-columns(
      [Left column content],
      hc-panel([Right column content]),
    )
  ],
  kicker: "TOPIC / 01",
)

#hc-closing()
```

Compile locally:

```bash
typst compile example.typ example.pdf
# or live rebuild:
typst watch example.typ example.pdf
```

Compatible by design with recent Typst releases (no external Typst packages). The `.typ` files have **not been compiled in this environment**, because the Typst CLI was unavailable; the independent PDF shows the intended visual direction, not a verified Typst export.

## Design tokens

| Token | Value | Role |
|---|---|---|
| Canvas | `#F7F6F1` | Warm off-white slide ground |
| Forest | `#264B45` | Strong sections and headlines |
| Sage | `#9CB8A8` | Gentle graphic accents |
| Mist | `#E2EBE4` | Quiet panels and cards |
| Ink | `#20332F` | Main text |
| Muted | `#647770` | Supporting copy |
| Clay | `#C77E68` | Very selective highlights |

Fonts: **Inter Display** for headlines and **Inter** for body. These are font *names*, not bundled assets. Install Inter on your computer for the intended appearance, or replace both names in the stylesheet with locally available fonts.

## Layout components

- `hc-cover(title, subtitle, overline:, meta:)`
- `hc-section(index, title, description:, label:)`
- `hc-slide(title, body, kicker:, section:)`
- `hc-quote(quote, source:, overline:)`
- `hc-closing(title:, subtitle:)`
- Content helpers: `hc-columns`, `hc-three`, `hc-panel`, `hc-card`, `hc-metric`, `hc-chip`, `hc-lead`, `hc-rule`, `hc-kicker`, `hc-subtle`

## Usage guidance

- Prefer 1 key point, 1 chart, or 2 short columns per slide.
- Keep body type around 18–24 pt; labels can be 11–13 pt.
- Avoid generic medical icons unless they convey a specific meaning.
- Do not place essential information in decorative page regions.
- The fixed slide canvas is 960 × 540 pt (16:9). Keep long copy from overflowing.
- Change colors in `hc-colors` and layout positions in the `hc-*` functions to tune the identity.
