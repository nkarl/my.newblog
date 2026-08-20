module Component.PlaceholderPage where

import Halogen.HTML as HH
import Utils (className)

view :: forall i p. String -> String -> HH.HTML i p
view title message =
  HH.div
    [ className "d-grid gap-3" ]
    [ HH.section
        [ className "card shadow-sm border-danger-subtle" ]
        [ HH.div
            [ className "card-body py-5 text-center" ]
            [ HH.h1_ [ HH.text title ] ]
        ]
    , HH.section
        [ className "card shadow-sm border-danger-subtle" ]
        [ HH.div
            [ className "card-body py-5 text-center" ]
            [ HH.h2_ [ HH.text message ] ]
        ]
    ]
