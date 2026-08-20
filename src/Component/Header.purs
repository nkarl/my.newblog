module Component.Header where

import Prelude

import Data.Route as Route
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Utils (className)
import Routing.Duplex (print)

component :: forall i p. HH.HTML i p
component =
  HH.nav
    [ className "navbar navbar-expand-lg bg-body-tertiary border-bottom" ]
    [ HH.div
        [ className "container-lg" ]
        [ HH.a
            [ className "navbar-brand d-inline-flex gap-2 fw-bold"
            , HP.href $ makeLocationHash Route.Home
            ]
            [ HH.span
                [ className "text-danger" ]
                [ HH.text "KARL'S" ]
            , HH.text "BLOG"
            ]
        , HH.button
            [ className "navbar-toggler"
            , HP.type_ HP.ButtonButton
            , HP.attr (H.AttrName "data-bs-toggle") "collapse"
            , HP.attr (H.AttrName "data-bs-target") "#navbarSupportedContent"
            , HP.attr (H.AttrName "aria-controls") "navbarSupportedContent"
            , HP.attr (H.AttrName "aria-expanded") "false"
            , HP.attr (H.AttrName "aria-label") "Toggle navigation"
            ]
            [ HH.span
                [ className "navbar-toggler-icon" ]
                []
            ]
        , HH.div
            [ className "collapse navbar-collapse", HP.id "navbarSupportedContent" ]
            [ HH.ul
                [ className "navbar-nav gap-lg-2" ]
                [ HH.li
                    [ className "nav-item" ]
                    [ HH.a
                        [ className "nav-link", HP.href $ makeLocationHash Route.Posts ]
                        [ HH.text "POSTS" ]
                    ]
                , HH.li
                    [ className "nav-item" ]
                    [ HH.a
                        [ className "nav-link", HP.href $ makeLocationHash Route.Resume ]
                        [ HH.text "RESUME" ]
                    ]
                , HH.li
                    [ className "nav-item" ]
                    [ HH.a
                        [ className "nav-link", HP.href $ makeLocationHash Route.Contact ]
                        [ HH.text "CONTACT" ]
                    ]
                , HH.li
                    [ className "nav-item" ]
                    [ HH.a
                        [ className "nav-link", HP.href $ makeLocationHash Route.Design ]
                        [ HH.text "DESIGN" ]
                    ]
                ]
            , HH.form
                [ className "d-flex gap-2 ms-lg-auto py-3 py-lg-0" ]
                [ HH.input
                    [ className "form-control fst-italic"
                    , HP.placeholder "Type to search..."
                    ]
                , HH.button
                    [ className "btn btn-outline-danger"
                    , HP.type_ HP.ButtonButton
                    ]
                    [ HH.text "SEARCH" ]
                ]
            ]
        ]
    ]

-- | make a path by converting a Route into a String
makeLocationHash :: Route.Route -> String
makeLocationHash = ("#" <> _) <<< print Route.routeCodec
