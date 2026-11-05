#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["typst==0.15.2"]
# ///
"""Build shared slide content with an active or saved theme."""

import argparse
import json
from pathlib import Path
import re

import typst

ROOT = Path(__file__).resolve().parents[1]


def resolve_theme(name):
    aliases = {"standard": "standard", "clinical": "clinical", "swiss": "clinical"}
    if name in aliases:
        path = ROOT / "theory/src/theme" / f"{aliases[name]}.typ"
    else:
        candidates = [Path(name), ROOT / name, ROOT / "various-themes" / (name if name.endswith(".typ") else f"{name}.typ")]
        path = next((candidate for candidate in candidates if candidate.is_file()), candidates[-1])
    path = path.resolve()
    if not path.is_file() or path.suffix != ".typ":
        raise ValueError(f"Theme not found: {name}")
    if not path.is_relative_to(ROOT):
        raise ValueError("The theme must be inside this repository.")
    return path


def build(theme, output, draft=False):
    text = theme.read_text()
    match = re.search(r"#let\s+(slide|theory)\s*\(([^)]*)\)", text)
    if not match:
        raise ValueError("The theme must define slide(...) or theory(...).")
    function, parameters = match.groups()
    arguments = ['"Theory"', "title", "body"] if "section" in parameters else ["title", "body"]
    if "source:" in parameters:
        arguments.append("source: none")
    if "topic:" in parameters:
        arguments.append("topic: topic")
    if "note:" in parameters:
        arguments.append("note: note")
    watermark = '''#set page(foreground: layout(size => block(width: size.width, height: size.height, align(bottom + left,
  pad(left: size.width * 0.005, bottom: size.height * 0.012,
    text(font: "Inter", size: size.height * 0.026, weight: "bold",
      fill: rgb("606060").transparentize(80%))[DRAFT],
  ),
))))''' if draft else ""
    # Earlier themes predate the shared content's palette and rendering interface.
    source = f'''#import {json.dumps('/' + theme.relative_to(ROOT).as_posix())} as chosen
#import "/theory/src/content.typ": slides
#let definitions = dictionary(chosen)
#let ink = definitions.at("ink", default: definitions.at("dark", default: rgb("172A3A")))
#let accent = definitions.at("accent", default: definitions.at("primary", default: rgb("176A96")))
#let paper = definitions.at("paper", default: rgb("F7FAFC"))
#let fill = definitions.at("node-fill", default: paper)
#let fallback-cover(title, subtitle, course) = [
  #text(size: 27pt, fill: accent)[#course]
  #v(50pt)
  #text(size: 92pt, weight: "bold")[#title]
  #v(24pt)
  #text(size: 42pt, weight: "bold")[#subtitle]
]
#let defaults = (
  ink: ink, accent: accent, paper: paper,
  gray: definitions.at("muted", default: rgb("596D7E")),
  node-fill: fill, radius: 0pt,
  api: accent, integration: accent, security: accent, deployment: accent,
  success: accent, warning: accent, danger: accent,
  api-fill: fill, security-fill: fill, deployment-fill: fill,
  workflow-fill: fill, clinical-data-fill: fill,
  presentation: body => body, cover: fallback-cover,
)
#let theme = defaults + definitions + (
  slide: (title, body, source: none, topic: "architecture", note: none) => chosen.{function}({', '.join(arguments)}),
)
#set page(width: 32cm, height: 18cm, margin: 1.8cm, fill: paper)
#set text(font: ("Inter", "DejaVu Sans"), size: 26pt, fill: ink, hyphenate: false)
#set par(spacing: 0pt, leading: 0.3em)
#set block(spacing: 0pt)
#set grid(align: left + top)
{watermark}
#show: theme.presentation
#slides(theme, with-cover: true)
'''
    pdf = typst.compile(source.encode(), root=str(ROOT), font_paths=[str(ROOT / "font")])
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(pdf)


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog="Examples: ./theory/build-slides.py standard | ./theory/build-slides.py clinical | ./theory/build-slides.py various-themes/standard-saturated.typ -o /tmp/slides.pdf",
    )
    parser.add_argument("theme", nargs="?", default="standard", help="standard, clinical, or a theme filename/path")
    parser.add_argument("-o", "--output", type=Path, help="Output PDF path")
    parser.add_argument("--draft", action="store_true", help="Add a bottom-left DRAFT watermark at 20%% opacity")
    args = parser.parse_args()
    try:
        theme = resolve_theme(args.theme)
        name = "swiss" if theme.stem == "clinical" else theme.stem
        filename = f"ecream-{name}.pdf" if theme.parent == ROOT / "various-themes" else f"ecream_{name}_slides.pdf"
        output = args.output or ROOT / "theory/builds" / filename
        if output.suffix.lower() != ".pdf":
            raise ValueError("The output filename must end in .pdf.")
        build(theme, output, draft=args.draft)
    except (ValueError, typst.TypstError) as error:
        parser.exit(1, f"{error}\n")
    print(output.resolve())


if __name__ == "__main__":
    main()
