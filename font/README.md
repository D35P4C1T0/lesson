# Bundled fonts

These original, unmodified font files are used through `--font-path font` by
local builds and the GitHub Actions workflow. No system font installation is
required.

| Family | Use | Included styles | Upstream version |
|---|---|---|---|
| Libertinus Serif | Standard theory deck; preserves its previous rendered typeface | Regular, Bold | 7.051 |
| Libertinus Sans | Parent lesson deck (`main.typ`) | Regular, Bold | 7.051 |
| Inter | Clinical deck body | Regular, Bold | 4.1 |
| Inter Display | Clinical deck headings and cover | Regular, Bold | 4.1 |
| Nunito Sans | Soft Play theme | Regular, Bold, ExtraBold | 3.101 |
| DejaVu Sans Mono | API/code excerpts | Book, Bold | 2.37 |
| DejaVu Sans | Symbols not present in Inter | Book | 2.37 |

The clinical deck now uses its intended Inter faces instead of the previous
Mac-specific Helvetica/Arial fallbacks.

## Sources and licenses

- [Libertinus 7.051](https://github.com/alerque/libertinus/releases/tag/v7.051):
  SIL Open Font License 1.1, included in `licenses/Libertinus-OFL.txt`.
- [Inter 4.1](https://github.com/rsms/inter/releases/tag/v4.1):
  SIL Open Font License 1.1, included in `licenses/Inter-OFL.txt`.
- [Nunito Sans static fonts](https://github.com/googlefonts/NunitoSans/tree/main/fonts/ttf):
  SIL Open Font License 1.1, included in `licenses/NunitoSans-OFL.txt`.
- [DejaVu 2.37](https://github.com/dejavu-fonts/dejavu-fonts/releases/tag/version_2_37):
  Bitstream Vera license and DejaVu public-domain additions, included in
  `licenses/DejaVu-LICENSE.txt`.

Build from the repository root, for example:

```bash
typst compile --root . --font-path font theory/src/main-standard.typ theory/builds/ecream_standard_slides.pdf
typst compile --root . --font-path font theory/src/main-swiss.typ theory/builds/ecream_swiss_slides.pdf
```
