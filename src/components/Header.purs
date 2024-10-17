module Component.Header where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

header :: forall i p. HH.HTML i p
header =
  HH.footer
    [ HP.style "padding:0.25em; border:solid black 1px; display:flex; justify-content:space-between;" ]
    [ HH.div
        [ HP.style "align-items:space-around; display:inline-flex; justify-content:space-around;" ]
        --[ HP.style "margin: 0 1em;align-items:center" ]
        [ HH.div
            [ HP.style "margin:0em; padding: 1em; border: dotted red 1px; height:48px; width:48px;" ]
            [ HH.a
              [ HP.href "/" ]
              [ HH.text "home" ]
            ]
        , HH.div
            [ HP.style "margin:0em; padding: 1em" ]
            [ HH.text "Hello, welcome to my blog!" ]
        ]
    , HH.ul
        [ HP.style "margin: 0em; padding: 1em; align-items:space-around; display:inline-flex; justify-content:space-around;" ]
        [ HH.li
            [ HP.style "margin:0 1em" ]
            [ HH.a
                [ HP.href "https://nkarl.github.io/resume" ]
                [ HH.text "resume" ]
            ]
        , HH.li
            [ HP.style "margin:0 1em" ]
            [ HH.a
                [ HP.href "https://nkarl.github.io/contact" ]
                [ HH.text "contact" ]
            ]
        ]
    ]
