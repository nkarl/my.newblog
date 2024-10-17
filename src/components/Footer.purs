module Component.Footer where

import Halogen.HTML as HH

footer :: forall i p. HH.HTML i p
footer =
  HH.footer_
    [ HH.div_
      [ HH.text "© 2024 Charles Lambert Nguyen. All rights reserved."
      ]
    ]
