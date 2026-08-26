# Karl's Blog

A static blog application built with PureScript, Halogen, and Routing.Duplex.

## Development

Requirements: Node.js 20 or newer and pnpm 11.

```sh
pnpm install
pnpm build
pnpm test
pnpm serve
```

`pnpm serve` builds the PureScript application, bundles it with esbuild, and serves `dist/` with rebuilds available by restarting the command.

## Project structure

- `src/Component/Router.purs` owns the application shell and selected page.
- `src/Data/Route.purs` is the single source of truth for browser routes.
- `data/` contains the Markdown and MDX article sources; `.wip/` is excluded.
- `scripts/build-content.mjs` validates front matter, converts and sanitizes Markdown, and generates `dist/posts.json`.
- `scripts/Capability/` contains composable article-rendering capabilities; TeX expressions are pre-rendered with KaTeX during the content build.
- `src/Data/Posts.purs` retrieves the generated static post data.
- `src/Page/` contains route-level page components.
- `DESIGN.md` maps information roles to Bootstrap patterns; `/#/design` renders the live component catalog.
- `ARCHITECTURE.md` records execution boundaries and the planned division of responsibility between PureScript and JavaScript/FFI adapters.

## Next steps

- Add decoding and HTTP tests around static post retrieval.
- Restore the two illustration assets referenced by the October 2024 MDX post.
- Add Mermaid diagram rendering as another content capability.
