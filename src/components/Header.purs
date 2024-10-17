module Component.Header where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

header :: forall i p. HH.HTML i p
header =
  HH.footer_
    [ HH.div_
        [ HH.text "Hello, welcome to my blog!"
        ]
    , HH.ul_
        [ HH.li_
            [ HH.a
                [ HP.href "https://nkarl.github.io/" ]
                [ HH.text "home" ]
            ]
        , HH.li_
            [ HH.a
                [ HP.href "https://nkarl.github.io/resume" ]
                [ HH.text "resume" ]
            ]
        , HH.li_
            [ HH.a
                [ HP.href "https://nkarl.github.io/contact" ]
                [ HH.text "contact" ]
            ]
        ]
    ]
