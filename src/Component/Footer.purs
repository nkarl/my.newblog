module Component.Footer where

import Halogen.HTML as HH
import MyUtils (className)

component :: forall i p. HH.HTML i p
component =
  HH.footer
    [ className "footer fixed-bottom mt-auto py-4 bg-body-tertiary" ]
    [ HH.div
        [ className "container d-flex d-wrap justify-content-center" ]
        [ HH.div_
            [ HH.span [ className "mb-3 mb-md-0 text-body-secondary" ]
                [ HH.text "© 2025 Charles Lambert Nguyen. All rights reserved."
                ]
            ]
        ]
    ]

-- <li class="ms-3"><a class="text-body-secondary" href="#"><svg class="bi" width="24" height="24"><use xlink:href="#twitter"/></svg></a></li>
