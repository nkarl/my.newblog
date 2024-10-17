module Component.Footer where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

footer :: forall i p. HH.HTML i p
footer =
  HH.footer
    [ HP.style "padding:1em; border:solid black 1px; text-align:center" ]
    [ HH.div_
      [ HH.text "© 2024 Charles Lambert Nguyen. All rights reserved."
      ]
    ]
