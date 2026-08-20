# Karl's Blog

A blog application built with PureScript, Halogen, Routing.Duplex, and Firebase
Realtime Database.

## Development

Requirements: Node.js 20 or newer and pnpm 11.

```sh
pnpm install
pnpm build
pnpm test
pnpm serve
```

`pnpm serve` builds the PureScript application, bundles it with esbuild, and
serves `dist/` with rebuilds available by restarting the command.

## Project structure

- `src/Component/Router.purs` owns the application shell and selected page.
- `src/Data/Route.purs` is the single source of truth for browser routes.
- `src/Data/Firebase.purs` retrieves post data.
- `src/Capability/ConvertMarkdown.*` is the Markdown-to-HTML FFI boundary.
- `src/Page/` contains route-level page components.

## Next steps

- Render converted Markdown in `PostDetail` using sanitized HTML.
- Move the Firebase URL into environment-specific configuration.
- Add loading, decoding, and HTTP tests around post retrieval.
- Replace the public Firebase write rule with authenticated authoring rules
  before adding a content publishing pipeline.
