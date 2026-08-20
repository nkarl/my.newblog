# Changelog

This file records notable development changes, fixed issues, and remaining
follow-up work. Add new entries under **Unreleased** as changes are made; move
them into a dated release section when publishing a release.

## Unreleased

### Changed

- Revived the latest application work on a local `develop` branch tracking
  `origin/implement/routing-for-page-components`.
- Standardized development on pnpm 11, PureScript 0.15.16, and Spago 1.0.4.
- Added local PureScript and Spago development dependencies and explicit pnpm
  build-script permissions.
- Regenerated the pnpm and Spago lockfiles and removed the conflicting npm
  lockfile.
- Simplified the route model to distinct `Home`, `Posts`, `Post id`, `Resume`,
  and `Contact` routes.
- Moved the shared header and footer into the router-owned application shell.
- Standardized the `Utils` and `Data.Firebase` module names.
- Sorted posts by `createdAt` instead of relying on Firebase object order.
- Replaced placeholder tests with route-codec round-trip tests.
- Added current setup, project structure, and next-step documentation.
- Disabled unauthenticated Firebase writes until an authenticated publishing
  workflow is implemented.

### Fixed

- Fixed post links whose default anchor destination could overwrite the
  programmatically selected detail route.
- Fixed post-detail navigation from the home page being discarded by an
  unhandled Halogen child output.
- Removed the overlapping Articles/Posts route and duplicate page component.
- Fixed the Firebase database URL containing a double slash.
- Fixed invalid JSON syntax in the Firebase rules file.
- Fixed the malformed viewport metadata.
- Fixed `clean` deleting dependency lockfiles.
- Updated the production bundle script for the current Spago/esbuild workflow.

### Remaining

- Convert post Markdown through `Capability.ConvertMarkdown` and render only
  sanitized HTML in `PostDetail`.
- Move the Firebase database URL into environment-specific configuration.
- Add HTTP, JSON-decoding, and component-state tests.
- Add authenticated Firebase authoring rules and a content publishing pipeline.
