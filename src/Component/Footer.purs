module Component.Footer where

import Halogen.HTML as HH
import Utils (className)

component :: forall i p. HH.HTML i p
component =
  HH.footer
    [ className "footer mt-4 py-4 bg-body-tertiary" ]
    [ HH.div
        [ className "container d-flex d-wrap justify-content-center" ]
        [ HH.div_
            [ HH.span
                [ className "mb-3 mb-md-0 text-body-secondary" ]
                [ HH.text "© 2026 Charles Lambert Nguyen. All rights reserved."
                ]
            ]
        ]
    ]
