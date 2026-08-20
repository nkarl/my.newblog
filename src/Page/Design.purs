module Page.Design where

import Prelude

import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Utils (className)

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState: identity
    , render: const catalog
    , eval: H.mkEval H.defaultEval
    }

catalog :: forall i p. HH.HTML i p
catalog =
  HH.div
    [ className "d-grid gap-5" ]
    [ intro
    , typography
    , actions
    , information
    , states
    ]

intro :: forall i p. HH.HTML i p
intro =
  HH.header_
    [ HH.h1_ [ HH.text "Design catalog" ]
    , HH.p
        [ className "lead" ]
        [ HH.text "A live inventory of the blog's Bootstrap patterns and information hierarchy." ]
    , HH.p
        [ className "small text-body-secondary" ]
        [ HH.text "Source of truth: DESIGN.md" ]
    ]

typography :: forall i p. HH.HTML i p
typography =
  section "Typography"
    [ HH.h1_ [ HH.text "Page title" ]
    , HH.h2_ [ HH.text "Section title" ]
    , HH.h3
        [ className "h5 mb-1" ]
        [ HH.text "Post-list title" ]
    , HH.p
        [ className "lead" ]
        [ HH.text "Lead copy introduces a page or summarizes an article." ]
    , HH.p_
        [ HH.text "Body copy carries the main reading experience in EB Garamond." ]
    , HH.p
        [ className "small text-body-secondary" ]
        [ HH.text "Metadata · Published August 20, 2026" ]
    ]

actions :: forall i p. HH.HTML i p
actions =
  section "Actions"
    [ HH.div
        [ className "d-flex flex-wrap gap-2" ]
        [ HH.button
            [ className "btn btn-danger", HP.type_ HP.ButtonButton ]
            [ HH.text "Primary action" ]
        , HH.button
            [ className "btn btn-outline-danger", HP.type_ HP.ButtonButton ]
            [ HH.text "Secondary action" ]
        , HH.a
            [ HP.href "#", className "align-self-center" ]
            [ HH.text "Text link" ]
        ]
    ]

information :: forall i p. HH.HTML i p
information =
  section "Information patterns"
    [ HH.article
        [ className "row align-items-baseline border-bottom py-3" ]
        [ HH.div
            [ className "col-12 col-sm-8" ]
            [ HH.h3
                [ className "h5 mb-1" ]
                [ HH.a [ HP.href "#/posts/example" ] [ HH.text "Example post title" ] ]
            ]
        , HH.div
            [ className "col-12 col-sm-4 text-body-secondary text-sm-end small" ]
            [ HH.text "August 20, 2026" ]
        ]
    , HH.div
        [ className "card shadow-sm border-danger-subtle mt-4" ]
        [ HH.div
            [ className "card-body py-5 text-center" ]
            [ HH.h3_ [ HH.text "Placeholder card" ]
            , HH.p
                [ className "mb-0 text-body-secondary" ]
                [ HH.text "Used for unfinished route-level content." ]
            ]
        ]
    ]

states :: forall i p. HH.HTML i p
states =
  section "Component states"
    [ HH.div [ className "alert alert-secondary" ] [ HH.text "Empty: No posts have been published yet." ]
    , HH.div [ className "alert alert-danger" ] [ HH.text "Error: Posts could not be loaded." ]
    , HH.div
        [ className "d-flex align-items-center gap-2 text-body-secondary" ]
        [ HH.div
            [ className "spinner-border spinner-border-sm"
            , HP.attr (H.AttrName "role") "status"
            , HP.attr (H.AttrName "aria-hidden") "true"
            ]
            []
        , HH.text "Loading posts…"
        ]
    ]

section :: forall i p. String -> Array (HH.HTML i p) -> HH.HTML i p
section title children =
  HH.section_
    [ HH.h2
        [ className "border-bottom pb-2 mb-3" ]
        [ HH.text title ]
    , HH.div_ children
    ]
