// Theory entry point; the shared lesson style is the default.
#import "src/theme/select.typ": select
#import "src/content.typ": slides
#let selected = select(sys.inputs.at("theory-theme", default: "standard"))
#show: selected.presentation
#slides(selected)
