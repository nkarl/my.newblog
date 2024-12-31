module Component.Header where

import Prelude

import Data.Route (Route(..), routeCodec)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import MyUtils (className)
import Routing.Duplex (print)

component :: forall i p. HH.HTML i p
component =
  HH.nav
    [ className "navbar navbar-expand-lg bg-body-tertiary" ]
    [ HH.div
        [ className "container-fluid" ]
        [ HH.a
            [ className "navbar-brand"
            , HP.style "display:inline-flex"
            , HP.href $ makePath Home
            ]
            [ HH.div
                [ HP.style "margin-right:0.5em" ]
                [ HH.text "KARL'S" ]
            , HH.text "BLOG"
            ]
        , HH.button
            [ className "navbar-toggler", HP.type_ HP.ButtonButton ]
            [ HH.span
                [ className "navbar-toggle-icon"
                , HP.attr (H.AttrName "data-bs-toggle") "collapse"
                , HP.attr (H.AttrName "data-bs-target") "#navbarSupportedContent"
                ]
                []
            ]
        , HH.form
            [ className "d-flex" ]
            [ HH.div
                [ className "collapse navbar-collapse", HP.id "navbarSupportedContent" ]
                [ HH.ul
                    [ className "navbar-nav me-auto mb-2 mb-lg-0" ]
                    [ HH.li
                        [ className "nav-item" ]
                        [ HH.a
                            [ className "nav-link active", HP.href $ makePath Articles ]
                            [ HH.text "ARTICLES" ]
                        ]
                    , HH.li
                        [ className "nav-item" ]
                        [ HH.a
                            [ className "nav-link", HP.href $ makePath Resume ]
                            [ HH.text "RESUME" ]
                        ]
                    , HH.li
                        [ className "nav-item" ]
                        [ HH.a
                            [ className "nav-link", HP.href $ makePath Contact ]
                            [ HH.text "CONTACT" ]
                        ]
                    ]
                ]
            , HH.input
                [ className "form-control me-2 ms-3 fst-italic fs-5"
                , HP.placeholder "Type to search. . ."
                ]
            , HH.button
                [ className "btn btn-outline-success"
                , HP.type_ HP.ButtonSubmit
                ]
                [ HH.text "SEARCH" ]
            ]
        ]
    ]
  where
  makePath = append "#" <<< print routeCodec
