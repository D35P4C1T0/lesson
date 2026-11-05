#import "diagrams/architecture.typ": architecture

// One source of content for both themes. Styling is supplied by each entry point.
#let slides(style, with-cover: false) = {
  let ink = style.ink
  let accent = style.accent
  let gray = style.gray
  let slide = style.slide
  let cover = style.cover
  let node(body, highlight: false, height: 94pt, tone: accent, tint: style.node-fill) = rect(
    width: 100%, height: height, inset: 14pt, radius: style.radius,
    fill: if highlight { tint } else { style.node-fill },
    stroke: (if highlight { 1.8pt + tone } else { 1pt + ink }),
  )[#align(left + horizon)[#text(size: 23pt, fill: ink)[#body]]]
  let arrow = align(center + horizon)[#text(size: 30pt, fill: accent)[→]]
  let down = block(width: 100%, height: 24pt)[#align(center + horizon)[#text(size: 23pt, fill: accent)[↓]]]
  let small(body) = text(size: 18pt, fill: gray)[#body]
  show raw.where(block: true): it => block(
    fill: color.mix((style.paper, 94%), (accent, 6%)),
    radius: calc.min(style.radius, 10pt),
    inset: (x: 18pt, y: 12pt),
    it,
  )
  [
    #if with-cover {
      cover("eCREAM", [Architecture, OpenAPI\ and Kubernetes], "Service Design and Architecture")
    }
    // Four sections; sources and teaching-example distinctions are in the speech.
    // Part 1 — purpose and the teaching journey, slides 2–4.
    #slide("What is eCREAM?", source: [D3.2 · Executive summary and introduction, pp. 4–5.])[
      #text(size: 28pt)[eCREAM is a European project enabling clinical research from emergency and acute-care data.]
      #v(32pt)
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 30pt, weight: "bold", fill: accent)[The software]
          #v(18pt)
          #text(size: 24pt)[WP3 develops an Emergency Department Electronic Health Record (ED-EHR).]
        ],
        [
          #text(size: 30pt, weight: "bold", fill: accent)[What it supports]
          #v(18pt)
          #text(size: 24pt)[A web application supports physicians and nurses, from triage to discharge, and connects to hospital systems.]
        ],
      )
    ]

    #slide("Why does eCREAM exist?")[
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 30pt, weight: "bold", fill: accent)[During care]
          #v(20pt)
          Clinicians need a record that follows the patient through a busy emergency department.
        ],
        [
          #text(size: 30pt, weight: "bold", fill: accent)[For research]
          #v(20pt)
          Researchers need structured, comparable information across hospitals.
        ],
      )
      #v(32pt)
      #text(size: 27pt, weight: "bold")[The design challenge: support local workflows while keeping data comparable.]
    ]

    #slide("Our fictional patient journey", source: [Teaching sequence based on D3.2 Fig. 5, p. 17; real paths can branch.])[
      #small[An API-based exercise; actual care pathways can branch.]
      #v(26pt)
      #grid(columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr), gutter: 14pt, align: horizon,
        node([#text(size: 20pt)[*Registration*\ Identify the patient.]], height: 110pt), arrow,
        node([#text(size: 20pt)[*Triage*\ Assign a priority.]], height: 110pt), arrow,
        node([#text(size: 20pt)[*Care & waiting*\ Track the episode.]], height: 110pt), arrow,
        node([#text(size: 20pt)[*Discharge*\ Close the episode.]], height: 110pt),
      )
      #v(26pt)
      #node([*Snapshot* · inspect the current patient and care-episode data.], highlight: true, height: 70pt)
      #v(22pt)
      #small[Keep the patient and care-episode IDs for later requests.]
    ]

    // Part 2 — architecture and access, slides 5–12.
    #slide("Why a hybrid architecture?", source: [D3.2 pp. 6–8; design choice at publication, not verified runtime.])[
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 30pt, weight: "bold", fill: accent)[Start with modules]
          #v(20pt)
          #text(size: 25pt)[A modular monolith keeps initial development and debugging simpler.]
        ],
        [
          #text(size: 30pt, weight: "bold", fill: accent)[Separate when useful]
          #v(20pt)
          #text(size: 25pt)[Independent services can evolve separately, but add network and distributed-operation failures.]
        ],
      )
      #v(32pt)
      #text(size: 26pt, weight: "bold")[Start with one modular application, keeping boundaries that allow modules to be separated later.]
      #v(20pt)
      #small[The architecture diagram does not prove that every module runs independently today.]
    ]

    #slide("eCREAM at a glance")[
      #small[Physicians and nurses use the application through their browser.]
      #v(26pt)
      #grid(columns: (1fr, auto, 1fr, auto, 1fr), gutter: 18pt, align: horizon,
        node([*Web interface*\ Screens for clinical work.], height: 112pt), arrow,
        node([*Backend*\ Rules and clinical operations.], highlight: true, height: 112pt), arrow,
        node([*Data stores*\ Patient records and application data.], height: 112pt),
      )
      #v(30pt)
      The backend also connects to existing hospital systems, such as laboratories.
    ]
    #slide("eCREAM structure", source: [D3.2 · Logical modules and main interfaces; direct dashboard-to-backend calls are also supported.])[
      #architecture(style)
    ]

    #slide("What the BFF does", source: [D3.2 · Illustrative patient-overview request through the Backend for Frontend.])[
      #small[A clinician opens a patient's overview.]
      #v(22pt)
      #grid(columns: (1fr, auto, 1fr, auto, 1.2fr), gutter: 18pt, align: horizon,
        node([*Dashboard*\ Requests the overview.], height: 110pt), arrow,
        node([*Web API / BFF*\ Coordinates calls.], highlight: true, height: 110pt), arrow,
        node([*Modules*\ Personal details.\ Observations.\ Medications.], height: 110pt),
      )
      #v(28pt)
      One combined response gives the screen the information it needs.
    ]

    #slide("What lives behind the API?", source: [D3.2 pp. 17–20; non-exhaustive logical module list.])[
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 28pt, weight: "bold", fill: accent)[Patient flow]
          #v(20pt)
          #text(size: 24pt)[*Patient Process Manager*\ Stages and transitions.]
          #v(24pt)
          #text(size: 24pt)[*Waiting List*\ Overview of emergency-department flow.]
        ],
        [
          #text(size: 28pt, weight: "bold", fill: accent)[Patient information]
          #v(20pt)
          #text(size: 24pt)[*Personal Information Data*\ Identifiers and demographics.]
          #v(24pt)
          #text(size: 24pt)[*Clinical Data · Diary · Medications*\ Records, notes and treatments.]
        ],
      )
      #v(26pt)
      #small[Process state describes where the patient is; clinical data records observations and care.]
    ]

    #slide("Identity and access", topic: "security", source: [D3.2 pp. 13–16; proposed authentication and authorization flow.], note: [#super[1] OIDC (OpenID Connect): authentication over OAuth 2.0 via an identity provider.])[
      #text(size: 26pt)[OIDC-based#super[1] login supplies tokens for subsequent API requests.]
      #v(26pt)
      #grid(columns: (1fr, auto, 1fr, auto, 1fr), gutter: 18pt, align: horizon,
        node([*Token*\ Client sends an access token.], height: 115pt), arrow,
        node([*Identity*\ Service validates it using JWKS.], highlight: true, height: 115pt, tone: style.security, tint: style.security-fill), arrow,
        node([*Permission*\ ABAC policy checks access.], height: 115pt),
      )
      #v(28pt)
      #grid(columns: (1fr, 1fr), gutter: 40pt,
        [#text(size: 25pt)[*Authentication*\ Who is calling?]],
        [#text(size: 25pt)[*Authorization*\ May they perform this action?]],
      )
    ]

    #slide("Service communication", topic: "integration", source: [D3.2 pp. 11–12; design, not confirmed sandbox runtime.])[
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 30pt, weight: "bold", fill: accent)[HTTP by default]
          #v(20pt)
          Modules expose synchronous HTTP endpoints for requests and responses.
        ],
        [
          #text(size: 30pt, weight: "bold", fill: accent)[Events where useful]
          #v(20pt)
          The design also allows asynchronous messages for interested components.
        ],
      )
      #v(30pt)
      #text(size: 24pt)[Planned internal mTLS protects service-to-service communication; user context travels with requests.]
      #v(22pt)
      #small[The FHIR API provides standardized data exchange for external clients.]
    ]

    #slide("Bridges adapt hospital systems", topic: "integration")[
      #grid(columns: (1fr, auto, 1.1fr, auto, 1fr), gutter: 18pt, align: horizon,
        node([*eCREAM*\ Laboratory request.], height: 110pt), arrow,
        node([*Exams Bridge*\ Stable internal interface.], highlight: true, height: 110pt, tone: style.integration, tint: style.security-fill), arrow,
        node([*Hospital LIS*\ Local protocol.], height: 110pt),
      )
      #v(28pt)
      Change the implementation for each hospital.\ Keep the interface used by the application consistent.
      #v(22pt)
      #small[Access control: requests still require identity and permission checks.]
    ]

    // Part 3 — OpenAPI and structured patient data, slides 13–16.
    #slide("OpenAPI: a shared API contract", topic: "api")[
      #text(size: 27pt)[An HTTP API described in JSON or YAML.]
      #v(20pt)
      #block(width: 805pt, height: 145pt)[
        #place(top + left, dx: 190pt, dy: 72pt,
          line(length: 92pt, stroke: (paint: accent, thickness: 1.5pt, dash: "dashed")),
        )
        #place(top + left, dx: 522pt, dy: 72pt,
          line(length: 73pt, stroke: (paint: accent, thickness: 1.5pt, dash: "dashed")),
        )
        #place(top + left, dx: 211pt, dy: 18pt, text(size: 15pt, fill: gray)[uses])
        #place(top + left, dx: 526pt, dy: 18pt, text(size: 15pt, fill: gray)[implements])
        #place(top + left, dx: 0pt, dy: 48pt, block(width: 185pt)[
          #text(size: 31pt, weight: "bold")[Client]
          #v(12pt)
          #text(size: 20pt)[Calls the API.]
        ])
        #place(top + left, dx: 282pt, dy: 0pt,
          rect(width: 240pt, height: 145pt, inset: 18pt,
            fill: color.mix((style.paper, 85%), (accent, 15%)),
            stroke: 1.5pt + accent, radius: calc.min(style.radius, 12pt),
          )[#align(center + horizon)[
            #text(size: 31pt, weight: "bold", fill: accent)[OpenAPI]
            #v(13pt)
            #text(size: 21pt)[Shared contract]
          ]],
        )
        #place(top + left, dx: 615pt, dy: 48pt, block(width: 190pt)[
          #text(size: 31pt, weight: "bold")[Server]
          #v(12pt)
          #text(size: 20pt)[Provides the API.]
        ])
      ]
      #v(28pt)
      #grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 24pt,
        [#text(size: 24pt, weight: "bold", fill: accent)[Operations]\ #v(10pt) #text(size: 20pt)[Methods and paths]],
        [#text(size: 24pt, weight: "bold", fill: accent)[Inputs]\ #v(10pt) #text(size: 20pt)[Parameters and bodies]],
        [#text(size: 24pt, weight: "bold", fill: accent)[Responses]\ #v(10pt) #text(size: 20pt)[Status codes and data]],
        [#text(size: 24pt, weight: "bold", fill: accent)[Security]\ #v(10pt) #text(size: 20pt)[Authentication requirements]],
      )
      #v(22pt)
      #small[FHIR models Patient and EpisodeOfCare; OpenAPI describes HTTP operations.]
    ]

    #slide("Reading an OpenAPI operation", topic: "api", source: [Illustrative patient-data endpoint and OpenAPI excerpt, not a verified eCREAM route.])[
      #grid(columns: (1.1fr, 1fr), gutter: 38pt,
        [
          #set raw(theme: auto)
          #show raw: set text(font: "DejaVu Sans Mono", size: 19pt, weight: "bold")
          #show raw: set par(leading: 0.6em)
          ```yaml
          /patients/{id}:
            get:
              parameters:
                - name: id
                  in: path
                  required: true
                  schema: {type: string}
              responses:
                '200':
                  description: Patient
                '404':
                  description: Not found
          ```
        ],
        [
          #text(size: 27pt, weight: "bold", fill: accent)[The request]
          #v(16pt)
          #text(size: 23pt)[GET /patients/123 retrieves structured data for patient 123.]
          #v(26pt)
          #text(size: 27pt, weight: "bold", fill: accent)[The response]
          #v(16pt)
          #text(size: 23pt)[200 returns patient data; 404 means the patient was not found.]
          #v(24pt)
          #small[Illustrative endpoint and contract, not a verified eCREAM API definition.]
        ],
      )
    ]

    #slide("OpenAPI for patient registration", topic: "api", source: [Fictional registration contract; complete request and response schemas in external_references/examples/patient-api.yaml.])[
      #set raw(theme: auto)
      #show raw: set text(font: "DejaVu Sans Mono", size: 19pt, weight: "bold")
      #show raw: set par(leading: 0.6em)
      ```yaml
      /patients:
        post:
          summary: Register a patient
          security: [{bearerAuth: []}]
          requestBody: {$ref: '#/components/requestBodies/Registration'}
          responses:
            '201': {description: Patient created}
            '400': {description: Invalid registration data}
            '401': {description: Missing or invalid token}
            '409': {description: Patient already registered}
      ```
      #v(18pt)
      #small[Fictional API contract · complete request and response schemas in patient-api.yaml.]
    ]

    #slide("One contract, several uses", topic: "api")[
      #node([*OpenAPI description* · operations and data schemas], highlight: true, height: 65pt, tone: style.api, tint: style.api-fill)
      #grid(columns: (1fr, 1fr, 1fr), down, down, down)
      #grid(columns: (1fr, 1fr, 1fr), gutter: 24pt,
        node([*Documentation*\ Explore the API.], height: 100pt),
        node([*Code generation*\ Create client code or server scaffolding.], height: 100pt),
        node([*Validation*\ Check data against schemas.], height: 100pt),
      )
      #v(28pt)
      #text(size: 24pt)[eCREAM used OpenAPI for all three. The backend still implements the operations and access rules.]
    ]

    // Part 4 — Kubernetes and the exercise handoff, slides 17–22.
    #slide("From Docker to Kubernetes", topic: "deployment")[
      #text(size: 29pt, weight: "bold")[Kubernetes coordinates containerized applications across a cluster of machines.]
      #v(32pt)
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 30pt, weight: "bold", fill: accent)[What you know]
          #v(18pt)
          An image packages the application. A container runs it.
        ],
        [
          #text(size: 30pt, weight: "bold", fill: accent)[What Kubernetes adds]
          #v(18pt)
          Decide where copies run, replace failed copies, and connect callers to them.
        ],
      )
    ]

    #slide("Pods and Deployments", topic: "deployment")[
      #grid(columns: (1fr, 1.4fr), gutter: 38pt, align: horizon,
        [
          *Pod*\ A unit that runs one or more containers.
          #v(26pt)
          *Deployment*\ Describes the image and how many copies should run.
        ],
        [
          #node([*Deployment* · two replicas], highlight: true, height: 65pt, tone: style.deployment, tint: style.deployment-fill)
          #grid(columns: (1fr, 1fr), down, down)
          #grid(columns: (1fr, 1fr), gutter: 20pt,
            node([*Pod A*\ API container], height: 100pt),
            node([*Pod B*\ API container], height: 100pt),
          )
          #v(20pt)
          #small[Example: each Pod runs the same API image.]
        ],
      )
    ]

    #slide("Services give callers a stable address", topic: "deployment")[
      #grid(columns: (1fr, 1.4fr), gutter: 38pt, align: horizon,
        [
          Pods can be replaced, and their addresses can change.
          #v(26pt)
          A *Service* gives callers a stable endpoint that routes requests to available Pods.
        ],
        [
          #node([*Service* · stable endpoint], highlight: true, height: 65pt, tone: style.deployment, tint: style.deployment-fill)
          #grid(columns: (1fr, 1fr), down, down)
          #grid(columns: (1fr, 1fr), gutter: 20pt,
            node([*Pod A*\ API container], height: 100pt),
            node([*Pod B*\ API container], height: 100pt),
          )
          #v(20pt)
          #small[Callers use the Service instead of individual Pod addresses.]
        ],
      )
    ]

    #slide("Keep two copies running", topic: "deployment", source: [Illustrative replica count, not an eCREAM sizing decision.])[
      #small[You declare the desired state: two API replicas.]
      #v(26pt)
      #grid(columns: (1fr, auto, 1fr, auto, 1fr), gutter: 18pt, align: horizon,
        node([*Two running*\ The requested state.], height: 120pt), arrow,
        node([*One fails*\ Only one remains.], height: 120pt), arrow,
        node([*Replacement*\ Kubernetes creates a new Pod.], highlight: true, height: 120pt, tone: style.deployment, tint: style.deployment-fill),
      )
      #v(28pt)
      Kubernetes continually works to restore the state you declared.
    ]

    #slide("Deploying eCREAM", topic: "deployment", source: [D3.2: planned containers on local or cloud clusters; Kubernetes is an orchestration option.])[
      #text(size: 28pt, weight: "bold")[The design plans containerized components on local or cloud clusters, with Kubernetes as an option.]
      #v(30pt)
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 28pt, weight: "bold", fill: accent)[Run the application]
          #v(18pt)
          #text(size: 24pt)[Images package the code; Kubernetes can manage running copies and their endpoints.]
        ],
        [
          #text(size: 28pt, weight: "bold", fill: accent)[Fit each hospital]
          #v(18pt)
          #text(size: 24pt)[Configure local workflows and Bridges. Keep clinical data beyond the lifetime of a container.]
        ],
      )
    ]
    #slide("Before the exercises", topic: "api", source: [API documentation URL and sandbox instructions supplied by the presenter; not verified against the live deployment.])[
      #text(size: 27pt, weight: "bold", fill: accent)[#link("https://ehr-test.ecreamproject.eu/dev")[Open the eCREAM API documentation → /dev]]
      #v(26pt)
      #grid(columns: (1fr, 1fr), gutter: 46pt,
        [
          #text(size: 25pt)[*Read before calling*\ Method, path, parameters, request body and responses.]
          #v(20pt)
          #text(size: 25pt)[Use the provided sandbox credentials.]
        ],
        [
          #text(size: 25pt)[*Keep the result*\ Save patient and care-episode IDs for subsequent requests.]
          #v(20pt)
          #text(size: 25pt)[Check the HTTP response before continuing.]
        ],
      )
      #v(24pt)
      #text(size: 21pt)[Use fictional data only. Do not send real patient data to an LLM.]
      #v(22pt)
      #text(size: 27pt, weight: "bold", fill: accent)[Next: Tanvir demonstrates registration and triage.]
    ]
  ]
}
