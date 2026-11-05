# e-CREAM - slide Typst

## Lesson Flow:
- We got aroround ~10-15 minutes to explain the theory (Matteo)
- Inside the theory we will surely talk about the architecture and OPENAPI
- During the ex1 (Tanvir) the students have to:
  1. `register` themself into e-cream as patient (withe name, surname, birthday, sex etc...)
  2. with a given payolad they send a req to `start the triage` (should be `_start` endpoint and it is based on `episodeOfCare`)
  3. studente ends their own triage with `_end` endpoint (note that the response should contain `priority code`)
- explain observability of a micro service system (Lorys)
- ex2 (Lorys) students:
  1. students make bad requests
  2. we shows grafana logs
- explain briefly Open-Ai endpoint (Marco)
- During the ex3 (Marco) the students have to:
  1. get the queue of patients via e-cream API
  2. take the JSON response and forward it to LiteLLM with a prompt asking something like: "how is the situation in the hospital?"
  3. get the response from the llm
- ex4 (Federico) students:
  1. using enpoint `/fhir/epofcare/$snapshot` students obtains their current status and all the data provided up to this point
  2. we simulate a lazy doctor that doesnt want to read the data, so students send the JSON response to LiteLLM to sum up. Save this response.
  3. since the patient is pretty much fine, we can `discharge`.
  4. the response from LiteLLM is the assignment to forward to professors.

## Repo Strucure

```text
.
├── main.typ                      # entry point
├── theme.typ                     # style
├── theory/                       # Matteo's chapter
│   └── slides.typ
├── ex1/                          # Tanvir's chapter
│   └── slides.typ
├── ex2/                          # Lorys's chapter
│   └── slides.typ
├── ex3/                          # Marco's chapter
│   └── slides.typ
├── ex4/                          # Federico's chapter
│   └── slides.typ
├── font/                         # Custom Font
│   └── README.md
├── .github/
│   └── workflows/
│       └── build-slides.yml      # gh action that compiles to PDF
├── .gitignore
└── README.md
```

## Compile on your pc

With [Typst](https://typst.app/) installed, inside the project directory run:

```bash
typst compile --font-path font main.typ slides.pdf
```

To automatically re-compile on changes:

```bash
typst watch --font-path font main.typ slides.pdf
```

Note that the produced pdf is already ignored.


