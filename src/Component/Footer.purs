module Component.Footer where

import Halogen.HTML as HH
import Utils (className)

component :: forall i p. HH.HTML i p
component =
  HH.footer
    [ className "mt-auto py-4 bg-body-tertiary border-top text-center text-body-secondary" ]
    [ HH.span_
        [ HH.text "© 2026 Charles Lambert Nguyen. All rights reserved." ]
    ]
