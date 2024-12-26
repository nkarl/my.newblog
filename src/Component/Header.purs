module Component.Header where

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import MyUtils (className)

header :: forall i p. HH.HTML i p
header =
  HH.nav [ className "navbar navbar-expand-lg bg-body-tertiary" ]
    [ HH.div [ className "container-fluid" ]
        [ HH.a [ className "navbar-brand", HP.style "display:inline-flex", HP.href "#" ] [ HH.div [ HP.style "margin-right:0.5em" ] [ HH.text "KARL'S" ], HH.text "BLOG" ]
        , HH.button [ className "navbar-toggler", HP.type_ HP.ButtonButton ]
            [ HH.span
                [ className "navbar-toggle-icon"
                , HP.attr (H.AttrName "data-bs-toggle") "collapse"
                , HP.attr (H.AttrName "data-bs-target") "#navbarSupportedContent"
                ]
                []
            ]
        , HH.form [ className "d-flex" ]
            [ HH.div [ className "collapse navbar-collapse", HP.id "navbarSupportedContent" ]
                [ HH.ul [ className "navbar-nav me-auto mb-2 mb-lg-0" ]
                    [ HH.li [ className "nav-item" ] [ HH.a [ className "nav-link active", HP.href "#" ] [ HH.text "HOME" ] ]
                    , HH.li [ className "nav-item" ] [ HH.a [ className "nav-link", HP.href "#" ] [ HH.text "ARTICLES" ] ]
                    ]
                ]
            , HH.input [ className "form-control me-2", HP.placeholder "search..." ]
            , HH.button [ className "btn btn-outline-success", HP.type_ HP.ButtonSubmit ] [ HH.text "Search" ]
            ]
        ]
    ]
