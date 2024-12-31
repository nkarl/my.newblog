module Page.Resume where

import Prelude

import Component.Footer as Footer
import Component.Header as Header
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import MyUtils (className)

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }
  where
  render _ =
    HH.div_
      [ Header.component
      , placeholder
      , Footer.component
      ]

placeholder :: forall i p. HH.HTML i p
placeholder =
  HH.div_
    [ HH.div
        [ className "card shadow mx-3 mt-3 border border-danger-subtle" ]
        [ HH.div
            [ className "container card-body my-5" ]
            [ HH.h1
                [ HP.style "text-align:center" ]
                [ HH.text "This is the Resume page."
                ]
            ]
        ]
    , HH.div
        [ className "card shadow mx-3 mt-3 border border-danger-subtle" ]
        [ HH.div
            [ className "container card-body my-5 min-vh-100" ]
            [ HH.h2
                [ HP.style "text-align:center" ]
                [ HH.text "It should display a list of work experience." ]
            ]
        ]
    ]
