# UI Design Language

This document is the source of truth for how the blog maps information roles to
Bootstrap components and utilities. Bootstrap supplies the visual vocabulary;
the rules below decide when each token is used.

The live catalog is available at `/#/design` during development.

## Principles

1. Prefer a documented Bootstrap component or utility over custom CSS.
2. Style information by its role, not by the page on which it appears.
3. Extract repeated markup into a PureScript view or component; keep the
   Bootstrap classes visible at the point where the pattern is implemented.
4. Add custom CSS only for article typography or behavior Bootstrap cannot
   express clearly.
5. Every new reusable visual pattern must be recorded in the inventory below
   and demonstrated on the design catalog page.

## Foundations

### Typography

| Information role | Bootstrap recipe | Usage |
|---|---|---|
| Page title | `h1` | One primary heading per page |
| Section title | `h2` | Major regions within a page |
| Post-list title | `h5 mb-1` | Scannable post links |
| Introduction | `lead` | Post description or page summary |
| Metadata | `small text-body-secondary` | Dates, types, IDs, supporting facts |
| Prose | Body defaults | Article and ordinary page copy |

The body uses EB Garamond through `--bs-body-font-family`. Font size and line
height are Bootstrap variable overrides in `dist/styles.css`.

### Color

Use Bootstrap's semantic roles rather than raw colors:

| Role | Token |
|---|---|
| Brand accent and destructive emphasis | `text-danger`, `btn-danger`, `btn-outline-danger` |
| Supporting information | `text-body-secondary` |
| Subtle page regions | `bg-body-tertiary` |
| Standard boundaries | `border`, `border-bottom`, `border-top` |
| Soft highlighted boundary | `border-danger-subtle` |

Color must not be the only way an interaction or state is communicated.

### Spacing

Use Bootstrap's `0`–`5` spacing scale. Default conventions:

| Context | Recipe |
|---|---|
| Main page rhythm | `py-4` |
| Component separation | `gap-3` or `mb-3` |
| Compact row | `py-2` |
| Standard row/card content | `py-3` |
| Spacious placeholder | `py-5` |

Avoid one-off inline spacing and custom pixel/rem values.

### Width and responsiveness

- The application shell uses `container-lg`.
- Reading and post-list content use `col-lg-8 mx-auto` or `col-lg-10 mx-auto`.
- Start mobile-first; add `sm`, `md`, or `lg` modifiers only when content needs
  a different relationship at that width.
- Post title/date rows stack below `sm` and form `8/4` columns at `sm` and up.
- Navigation collapses below Bootstrap's `lg` breakpoint.

## Pattern inventory

| Pattern | Owner | Bootstrap recipe | Consumers |
|---|---|---|---|
| Application shell | `Component.Router` | `d-flex min-vh-100 flex-column` | All routes |
| Main content | `Component.Router` | `container-lg py-4 flex-grow-1` | All routes |
| Primary navigation | `Component.Header` | `navbar navbar-expand-lg` | Application shell |
| Site footer | `Component.Footer` | `bg-body-tertiary border-top text-center` | Application shell |
| Post collection | `Component.PostList` | Responsive `row` with `col-sm-8/4` | Home, Posts |
| Post detail | `Component.PostDetail` | `col-lg-8 mx-auto` | Post route |
| Metadata | `Component.PostDetail`, `Component.PostList` | `small text-body-secondary` | Dates and post facts |
| Placeholder page | `Component.PlaceholderPage` | `card shadow-sm border-danger-subtle` | Resume, Contact |
| Loading state | Data components | Plain status copy | Post list/detail |
| Error state | Data components | `alert alert-danger` | Post list/detail |
| Empty state | Data components | `alert alert-secondary` | Empty collections |

## Component states

Every data-backed component should account for:

- Loading: brief neutral copy or a spinner when the wait is meaningful.
- Error: `alert alert-danger` with a useful message.
- Empty: `alert alert-secondary` explaining that no content exists.
- Ready: the normal content pattern.

Interactive controls must include visible focus behavior, an accessible name,
and a native element appropriate to the action.

## Custom CSS boundary

Custom CSS currently owns only Bootstrap body typography variable overrides and
prose-specific rules beneath `.post-content`: code blocks, inline code,
blockquotes, tables, and responsive images. Generated article HTML must keep all
custom styling inside that boundary.

## Change checklist

When introducing or changing UI:

1. Identify the information role.
2. Reuse an inventory pattern if one exists.
3. Choose Bootstrap tokens and verify mobile and desktop behavior.
4. Update this document if the decision is reusable.
5. Add or update the example on `/#/design`.
6. Record the change in `CHANGELOG.md`.
