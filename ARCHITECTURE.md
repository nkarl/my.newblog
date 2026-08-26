# Application Architecture

This document records architectural boundaries, their rationale, and possible future changes. It is descriptive of the current system and prescriptive only where a target direction is explicitly identified.

## System planes

The blog has two primary execution planes.

### Content build plane

The build plane runs under Node.js before deployment. It currently owns:

- Discovering article files under `data/`.
- Excluding work-in-progress sources.
- Parsing front matter.
- Deriving article identifiers and publication timestamps.
- Rewriting and validating internal links.
- Converting Markdown to HTML.
- Sanitizing author-provided HTML.
- Rendering TeX through KaTeX.
- Publishing the post index and renderer assets under `dist/`.

Most of this plane is currently implemented in JavaScript under `scripts/`.

### Browser application plane

The browser plane is implemented primarily in PureScript and Halogen. It owns:

- Fetching and decoding the generated post index.
- Modeling routes with Routing.Duplex.
- Selecting route-level pages.
- Modeling loading, error, empty, and ready states.
- Constructing and updating the application DOM.
- Coordinating future interactive component lifecycles.

The browser does not discover or compile source articles. It consumes the generated `dist/posts.json` artifact.

## Current assessment

The current boundary is reasonable for a production-oriented static site: Node.js owns filesystem access and the JavaScript Markdown ecosystem, while PureScript owns typed browser state and UI behavior.

However, the content builder currently combines two different categories:

1. Platform and library mechanics, which naturally belong behind JavaScript adapters.
2. Blog-specific policy and transformations, which are suitable for a PureScript functional core.

As a result, JavaScript currently performs most content-domain work. This is a missed opportunity if learning and practicing PureScript remains a goal of the project.

## Desired responsibility boundary

### JavaScript and FFI adapters should own

- Node.js filesystem calls.
- Invoking the Markdown and unified ecosystems.
- Configuring library-specific remark and rehype plugins.
- Invoking KaTeX, Mermaid, or similar JavaScript renderers.
- Low-level DOM calls required by interactive third-party libraries.

These modules should expose small, explicit contracts and avoid owning blog policy.

### PureScript should own

- Article, front-matter, and rendered-content types.
- Structured content errors.
- Front-matter interpretation and validation.
- Slug and publication-state rules.
- Sorting and post-index construction.
- Internal-link modeling and validation.
- Content-pipeline orchestration.
- Accumulation and reporting of build failures.
- Browser component lifecycle decisions for interactive islands.

The guiding rule is:

> PureScript owns policy and reasoning; JavaScript owns platform and library mechanics.

## Target content architecture

A future PureScript-oriented build plane could have the following shape:

```text
Content.Main.purs
├── Content.Types.purs
├── Content.FrontMatter.purs
├── Content.Slug.purs
├── Content.Links.purs
├── Content.Validate.purs
└── Capability
    ├── FileSystem.purs/.js
    ├── Markdown.purs/.js
    ├── RenderTex.purs/.js
    └── SanitizeHtml.purs/.js
```

The pure modules would model transformations such as:

```purescript
parseArticleSource
  :: FilePath
  -> String
  -> Either (Array ContentError) ArticleSource

buildPostIndex
  :: Array RenderedArticle
  -> Either (Array ContentError) PostIndex
```

Effectful capabilities would remain narrow:

```purescript
readText :: FilePath -> Aff String

renderMarkdown :: String -> Aff String

writePostIndex :: FilePath -> PostIndex -> Aff Unit
```

The build entry point would compose those functions without implementing their platform details.

## Rendering capabilities

Build capabilities under `scripts/Capability/` currently establish the first version of a renderer boundary:

- `SanitizeContent` constrains author-provided HTML.
- `RenderTex` owns TeX parsing, KaTeX policy, output validation, and assets.

Future build renderers such as Mermaid should follow the same pattern while the pipeline remains JavaScript-based.

An interactive browser island has an additional boundary:

```text
Halogen component lifecycle
    ↓
PureScript capability contract
    ↓
JavaScript FFI adapter
    ↓
Third-party browser library
```

PureScript should decide when the island mounts, updates, and unmounts. JavaScript should perform only library-specific DOM work.

## Runtime capability naming

Modules under `Data.*` should preferably contain types and pure transformations. Operations such as HTTP retrieval are effects and may eventually move from `Data.Posts` to a name such as `Capability.LoadPosts`.

This is a target convention, not an immediate migration requirement.

## Incremental migration path

Do not rewrite the content pipeline all at once. A useful progression is:

1. Introduce PureScript content types and error types.
2. Port front-matter parsing, slug derivation, and link validation as pure functions.
3. Add focused tests for those pure modules.
4. Introduce thin filesystem and Markdown FFI capabilities.
5. Move pipeline orchestration into `Content.Main`.
6. Reduce `scripts/build-content.mjs` to a loader or remove it.

Each step should leave the existing content build operational and should be recorded in `CHANGELOG.md`.

## Deferred decisions

- Whether the learning value justifies a complete PureScript content builder.
- Whether generated post data should remain JSON or become a generated PureScript module.
- Whether Mermaid should be pre-rendered or implemented as a client-side interaction island.
- Whether runtime post loading should remain HTTP-based or be compiled into the browser bundle.
