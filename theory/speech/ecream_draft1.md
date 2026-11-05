# eCREAM: Architecture, OpenAPI and Kubernetes

*Matteo Girardi · Target 13–14 minutes, within the 10–15 minute theory segment. Four sections: purpose and patient journey; architecture; OpenAPI; Kubernetes and exercise handoff. Architectural claims describe the public D3.2 proposal dated 29 November 2024, not a verified test-deployment topology. OpenAPI's three project-specific uses and the sandbox instructions were supplied by the presenter. The patient endpoints, registration contract, JSON schemas and replica counts are teaching examples; all patient data is fictional.*

*Slide map: Cover → 1; Part 1 → 2–4; Part 2 → 5–12; Part 3 → 13–16; Part 4 → 17–22.*

## Part 1 — What eCREAM Is and Why It Exists
*Approximately 2 minutes · slides 2–4*

**Slide 2 — What is eCREAM?**

eCREAM stands for “enabling Clinical Research in Emergency and Acute care Medicine through automated data extraction.” The project aims to make emergency-care data useful for clinical research.

Our focus is WP3: designing and developing an Emergency Department Electronic Health Record, or ED-EHR. This web application supports physicians and nurses from triage through treatment to discharge, and connects to clinical and administrative systems already used by the hospital.

**Slide 3 — Why does eCREAM exist?**

There are two needs to satisfy together. Clinicians need software that fits everyday emergency care. Researchers need structured, comparable information across hospitals.

Hospitals have different workflows and IT systems. The design must accommodate those differences while preserving common functionality and data structures. That challenge explains many of the architectural choices we will examine.

**Slide 4 — Our fictional patient journey**

The practical lesson follows a fictional patient through API calls. Registration creates or identifies the patient. Triage assigns a priority, and the care episode progresses through the emergency department. The waiting list gives an overall view of patient flow.

A snapshot lets us inspect the current patient and care-episode data. Discharge concludes our exercise scenario. This is a teaching sequence: real care pathways can branch, and a snapshot is a way to inspect data rather than a clinical stage.

Keep the patient and care-episode identifiers returned by the API. Later requests refer to those same entities.

## Part 2 — eCREAM Structure: From the Whole System to Its Components
*Approximately 4½ minutes · slides 5–12*

**Slide 5 — Why a hybrid architecture?**

The proposed architecture begins with a modular monolith: one deployable application with clearly separated responsibilities. This simplifies initial development and debugging.

Separate services can evolve and be deployed independently, but introduce network failures and more difficult distributed operations. The proposal therefore keeps boundaries that would allow cohesive modules to be separated when appropriate.

This is the design choice described in 2024. It does not establish what runs independently in today's test installation.

**Slide 6 — eCREAM at a glance**

Start with three broad responsibilities. Clinicians use a web interface. A backend implements application rules and clinical operations. Data stores preserve the information the application needs.

The backend also communicates with existing hospital systems, such as laboratories. eCREAM connects its users, stored clinical information and the hospital's infrastructure.

**Slide 7 — eCREAM structure**

Now zoom in. The Admin Dashboard handles configuration and permissions; the ER Dashboard supports clinical work. The Web API acts as a Backend for Frontend, or BFF, while a FHIR API supports standardized exchange with external clients.

Core functions handle identity and platform settings. Process modules manage patient flow. Data modules manage personal and clinical information. Bridges connect those functions to hospital systems.

These boxes show responsibilities and interfaces. They are not a deployment map, and a box does not automatically imply a separate microservice or container.

**Slide 8 — What the BFF does**

Suppose a clinician opens a patient's overview. The screen may need personal details, observations and medications from different modules.

The BFF can coordinate those calls and return a combined response tailored to the screen. The modules retain their own responsibilities. The design also permits direct dashboard-to-backend calls, so the BFF is not necessarily on every request path.

**Slide 9 — What lives behind the API?**

The Patient Process Manager tracks stages and transitions, while the Waiting List provides a global view of emergency-department flow.

Personal Information Data handles identifiers and demographics. Clinical Data, Diary and Medications handle clinical records, notes and treatment information. The design models and exchanges clinical data using FHIR resource structures.

A useful distinction is between process state and clinical facts: “waiting for assessment” describes a patient's position in the workflow; a recorded observation describes their clinical information.

**Slide 10 — Identity and access**

The proposed login follows OpenID Connect, or OIDC: an authentication layer built on OAuth 2.0 that lets an application verify the user through an identity provider. The Authentication module provides tokens that clients present with subsequent API requests.

A receiving service validates the token using signing keys published through a JSON Web Key Set, or JWKS. The Permissions module then applies Attribute-Based Access Control, or ABAC, to decide whether the caller may perform that action on that resource.

Follow the diagram: present a token, validate identity, then check permission. Knowing who is calling is different from deciding what they may do.

**Slide 11 — Service communication**

Modules primarily expose synchronous HTTP endpoints: one component makes a request and receives a response. The design also allows asynchronous events for components interested in a change.

For internal communication between services, the design plans mutual TLS, or mTLS, and propagation of the initiating user's context. External interoperability is handled through the FHIR API.

These are design mechanisms; we have not verified which are enabled in the test environment.

**Slide 12 — Bridges adapt hospital systems**

An Exams Bridge illustrates how local differences are isolated. eCREAM uses a consistent internal interface, while the Bridge handles the formats and protocols required by a hospital's laboratory system.

Another hospital can provide a different implementation without changing the interface used by the rest of the application. This is the Adapter pattern applied to hospital integration.

These boundaries lead to our next question: how do communicating components agree on the HTTP operations and data they exchange?

## Part 3 — OpenAPI in Practice
*Approximately 3 minutes · slides 13–16*

**Slide 13 — OpenAPI: a shared API contract**

OpenAPI describes HTTP APIs in a machine-readable format, usually YAML or JSON. The client uses this contract to build requests, and the server implements the described operations. The diagram shows their shared agreement.

The four groups below show what they agree on: methods and paths, inputs, responses, and security requirements.

FHIR and OpenAPI are complementary. FHIR defines healthcare resources such as Patient and EpisodeOfCare, together with exchange conventions. OpenAPI describes the HTTP operations exposed by a particular API implementation.

**Slide 14 — Reading an OpenAPI operation**

Our simplified teaching endpoint is `GET /patients/{id}`. It is not a verified eCREAM route; the exercises use the actual documentation at `/dev`.

The braces mark a value supplied in the URL. `/patients/123` requests data for patient 123. The parameter is required and has string type, even when its value consists of digits.

The excerpt describes a successful `200` response and a `404` response when the patient is not found. A complete description can also define security requirements and the response body schema.

**Slide 15 — OpenAPI for patient registration**

Now give the contract a practical purpose: registering a patient before triage. This fictional `POST /patients` operation accepts demographic data and creates a patient record.

The `security` field requires a bearer token. The request body references a reusable Registration definition containing the required external identifier, name and birth date. The full example in our reference folder includes those schemas and sample payloads.

The client must handle several outcomes. `201` means a record was created; the complete response returns a patient ID and its Location header. `400` means invalid registration data, `401` means a missing or invalid token, and `409` means the external identifier is already registered.

This is what makes the contract useful in practice: it describes the operation's intent, expected input, access requirement and outcomes. These definitions are invented for the lesson, not copied from eCREAM's actual API.

**Slide 16 — One contract, several uses**

A description can support documentation, code generation and data validation. These were the three OpenAPI uses confirmed for eCREAM during preparation.

Documentation helps people explore operations. Generators can produce client code or server scaffolding. Validation tools can compare data with schemas. The backend still implements business logic and access checks; a specification alone does not enforce them on a running server.

We can now describe how to call the application. Next, we will look at keeping it running.

## Part 4 — Kubernetes, Starting from Docker
*Approximately 4 minutes, including the handoff · slides 17–22*

**Slide 17 — From Docker to Kubernetes**

With Docker, an image packages the application and its dependencies, and a container runs it. Now imagine running several copies across machines: something must choose where they run, replace failed copies and connect callers to them.

Kubernetes coordinates that work across a cluster, a set of machines managed together. Each machine is called a node. We still use container images, but describe how we want the application to run.

**Slide 18 — Pods and Deployments**

A Pod runs one or more containers together. In this example, each Pod contains one API container.

A Deployment describes which image to run and how many copies are wanted. We ask for two replicas, so two Pods run the same image. Read the diagram as a desired configuration and the running units that satisfy it.

**Slide 19 — Services give callers a stable address**

Pods can be replaced, and their addresses can change. A Service provides a stable endpoint and routes requests to available matching Pods.

Callers therefore do not need to keep track of every Pod address. The Service handles reaching the application; the Deployment manages the requested copies.

**Slide 20 — Keep two copies running**

Kubernetes works from a declared desired state. We ask for two API replicas. If one Pod disappears, Kubernetes works to create a replacement and restore the count.

This is reconciliation: comparing what exists with what was requested and working to close the gap. Replacement takes time and depends on available resources. The Service remains the endpoint callers use as individual Pods change.

**Slide 21 — Deploying eCREAM**

The deployment plan provides containerized components for local or cloud clusters, naming Kubernetes as an orchestration example. These concepts explain how that deployment could be managed; the two replicas are not a documented eCREAM sizing decision.

Each hospital still needs its workflows and Bridges configured. Clinical data must also survive application replacement. The design selects PostgreSQL but does not specify a production cluster topology, volume configuration or backup strategy.

**Slide 22 — Before the exercises**

Open `https://ehr-test.ecreamproject.eu/dev` and use the provided sandbox credentials. Select the actual documented operation; keep its method and path visible, then read Parameters, Request body and Responses before executing it.

Use fictional data only, and do not paste real patient data into an LLM. Keep response IDs for the same patient and care episode, and check the HTTP response before continuing to the next stage.

Tanvir will now demonstrate registration and triage.

---

## Source Notes — Not Part of the Spoken Presentation

- [eCREAM D3.2 — Architectural Design](../eCream_docs/D3.2%20Architectural%20design.docx%20%281%29.pdf), 29 November 2024: purpose, acronym and WP3, pp. 3–5; architectural tradeoffs and hybrid choice, pp. 6–8; dashboards, BFF, interfaces and communication, pp. 10–13; token issuance, JWKS and ABAC, pp. 13–16; patient workflow, Fig. 5, p. 17; process and data modules, pp. 17–19; Bridges, pp. 19–20; software stack and container deployment, pp. 20–22. Page numbers are the PDF's printed numbers. The document is a design proposal, not evidence of the current test deployment.
- The patient-journey diagram is a teaching simplification. The registration/triage, waiting-list, snapshot and discharge exercise sequence and the handoff to Tanvir were supplied by the presenter. Snapshot is an inspection operation, not a clinical stage established by Fig. 5.
- OpenAPI definitions follow the [OpenAPI Specification 3.0.4](https://spec.openapis.org/oas/v3.0.4.html) and the OpenAPI Initiative's guides to [description structure](https://learn.openapis.org/specification/structure.html) and [API endpoints](https://learn.openapis.org/specification/paths.html). Documentation, code generation and validation uses in eCREAM were confirmed by the presenter; specific tools were not identified. The `/patients/{id}` and `POST /patients` routes and their schemas are fictional teaching examples, not the actual eCREAM API.
- FHIR is mentioned briefly to explain its relationship with OpenAPI. D3.2 pp. 11–13 and 18 establish the proposed interoperability interface and use of resource structures. For definitions, see the HL7 [overview](https://hl7.org/fhir/R4/overview.html), [Patient](https://hl7.org/fhir/R4/patient.html) and [EpisodeOfCare](https://hl7.org/fhir/R4/episodeofcare.html) documentation. R4 is a teaching reference, not a verified version used by the sandbox.
- Kubernetes concepts follow the official [overview](https://kubernetes.io/docs/concepts/overview/), [Pods](https://kubernetes.io/docs/concepts/workloads/pods/), [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [Services](https://kubernetes.io/docs/concepts/services-networking/service/) documentation. The resource topology and replica count are illustrative.
- The [test API documentation](https://ehr-test.ecreamproject.eu/dev) URL and access instructions were supplied by the presenter. The page could not be retrieved through the web tool during preparation; no authenticated requests, live endpoint execution or deployment verification were performed.

- The OIDC definition on slide 10 follows the OpenID Foundation's [How OpenID Connect Works](https://openid.net/developers/how-connect-works/).
