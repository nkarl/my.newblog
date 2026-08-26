# Build capabilities

Each module in this directory owns one optional article-rendering concern. The content builder composes their parser plugins, renderer configuration, and static assets without knowing their implementation details.

- `SanitizeContent.mjs` constrains author-provided HTML before trusted renderers run.
- `RenderTex.mjs` parses TeX delimiters, configures KaTeX, and publishes the required browser stylesheet and fonts.

Future renderers such as Mermaid should use the same boundary. Client-side interaction islands should additionally own their browser entry point and only attach to markup emitted by their corresponding build capability.
