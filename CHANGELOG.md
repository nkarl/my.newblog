# Changelog

This file records notable development changes, fixed issues, and remaining follow-up work. Add new entries under **Unreleased** as changes are made; move them into a dated release section when publishing a release.

## Unreleased

### Changed

- Reflowed project Markdown so prose paragraphs and list items use semantic rather than fixed-width line breaks.
- Added `ARCHITECTURE.md` to record the current JavaScript/PureScript boundary, the desired functional-core/FFI split, and an incremental migration path.
- Added composable build capabilities under `scripts/Capability/`, separating authored-HTML sanitization and TeX rendering from article discovery.
- Added build-time KaTeX rendering for standard `$...$` and `$$...$$` syntax, including local browser styles/fonts and responsive display equations.
- Made `data/` the source of truth for published articles and excluded `data/.wip/` from publication.
- Added a build-time content pipeline that validates front matter, converts Markdown/MDX to HTML, sanitizes it, rewrites internal post links, and emits `dist/posts.json`.
- Replaced Firebase retrieval with local static post loading through `Data.Posts` and rendered sanitized article HTML in `PostDetail`.
- Added scoped article typography for code, blockquotes, tables, and images.
- Aligned post loading, error, and empty states with the documented Bootstrap design patterns.
- Added `DESIGN.md` as the source of truth for information hierarchy, Bootstrap recipes, responsive conventions, and component ownership.
- Added a live `/#/design` catalog covering typography, actions, information patterns, and loading/error/empty states.
- Consolidated layout, spacing, color, responsive, card, and control styling on Bootstrap's constrained component and utility vocabulary.
- Reduced `dist/styles.css` to global typography and Markdown presentation that Bootstrap does not express directly.
- Extracted the repeated placeholder-card markup into a reusable PureScript view while keeping its visual configuration in Bootstrap classes.
- Made post-list rows responsive with Bootstrap's grid and breakpoint tokens.
- Corrected the Bootstrap navbar structure and moved its toggle and accessibility attributes onto the toggle button.
- Revived the latest application work on a local `develop` branch tracking `origin/implement/routing-for-page-components`.
- Standardized development on pnpm 11, PureScript 0.15.16, and Spago 1.0.4.
- Added local PureScript and Spago development dependencies and explicit pnpm build-script permissions.
- Regenerated the pnpm and Spago lockfiles and removed the conflicting npm lockfile.
- Simplified the route model to distinct `Home`, `Posts`, `Post id`, `Resume`, and `Contact` routes.
- Moved the shared header and footer into the router-owned application shell.
- Standardized the `Utils` and `Data.Firebase` module names.
- Sorted posts by `createdAt` instead of relying on Firebase object order.
- Replaced placeholder tests with route-codec round-trip tests.
- Added current setup, project structure, and next-step documentation.
- Disabled unauthenticated Firebase writes until an authenticated publishing workflow is implemented.

### Fixed

- Prevented work-in-progress content and unsupported MDX import statements from appearing in the published post list.
- Prevented generated article markup from injecting scripts or unsafe attributes into the page.
- Fixed post links whose default anchor destination could overwrite the programmatically selected detail route.
- Fixed post-detail navigation from the home page being discarded by an unhandled Halogen child output.
- Removed the overlapping Articles/Posts route and duplicate page component.
- Fixed the Firebase database URL containing a double slash.
- Fixed invalid JSON syntax in the Firebase rules file.
- Fixed the malformed viewport metadata.
- Fixed `clean` deleting dependency lockfiles.
- Updated the production bundle script for the current Spago/esbuild workflow.

### Remaining

- Add HTTP, JSON-decoding, and component-state tests.
- Restore the missing images referenced by the October 2024 MDX article.
- Add Mermaid rendering as another article capability.
