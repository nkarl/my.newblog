module Main where

import Prelude

import Component.Footer as Footer
import Component.Header as Header
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import MyUtils (className)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI
      component
      unit
      body

component :: ∀ q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }
  where

  render :: forall s a. s -> H.ComponentHTML a () m
  render _ =
    HH.div_ -- [className "d-flex flex-column h-100"]
      [ Header.component
      , placeholder
      , Footer.component
      ]

placeholder :: forall i p. HH.HTML i p
placeholder =
  HH.div
    --[ HP.style "min-height:79vh; margin: 1em 0; padding: 4rem; border:solid red 1px;" ]
    [ className "card" ]
    [ HH.div [ className "container card-body mt-5 min-vh-100" ]
        [ HH.h1
            [ HP.style "text-align:center" ]
            [ HH.text "Lorem Ipsum" ]
        , HH.p_
            [ HH.text "Lorem ipsum odor amet, consectetuer adipiscing elit. Neque penatibus vulputate nisi quisque ac parturient magnis. Nisi molestie auctor sit ligula, suspendisse volutpat in cubilia. Efficitur pellentesque lectus erat risus ligula rhoncus taciti sit justo. Dis duis rhoncus; class ad iaculis blandit ridiculus tempor. Commodo vestibulum nullam sit ex nascetur lacus dis. Habitasse id tempus dignissim netus ullamcorper purus. Class ornare parturient semper natoque himenaeos penatibus morbi. Commodo duis nunc eget himenaeos maximus rhoncus; senectus a suscipit. Tempus cras efficitur dignissim facilisi gravida proin?"
            ]
        , HH.p_
            [ HH.text "Efficitur placerat facilisis luctus ad, non nulla. Iaculis at euismod risus donec ex ante scelerisque ultrices? Lacinia nisi hendrerit dolor mattis mattis condimentum eros. Praesent torquent leo consequat ipsum dis bibendum. Risus dictum sem venenatis; hendrerit lobortis risus metus. Varius enim sagittis penatibus molestie fames ornare penatibus magna. Commodo platea malesuada gravida, nam velit ultricies rutrum."
            ]
        , HH.p_
            [ HH.text "Suspendisse maximus quisque risus dictumst lacinia. Consequat fusce massa, praesent egestas cursus aptent. Aliquet diam orci dolor netus tempus. Ipsum vehicula dignissim elementum natoque facilisi himenaeos ipsum faucibus augue. Tortor molestie cras efficitur lacinia non. Sodales vestibulum ridiculus luctus sollicitudin natoque ridiculus. Nostra arcu egestas cubilia nullam nullam porttitor integer."
            ]
        , HH.p_
            [ HH.text "Nisl purus lorem imperdiet varius et massa natoque penatibus fames. Leo enim ad magna porttitor laoreet; duis ac erat. Mollis enim per aptent potenti fermentum finibus volutpat ultricies. Praesent nibh euismod, facilisi curabitur mattis enim semper nisl. Ante neque vel metus leo vivamus scelerisque hendrerit. Praesent fusce ad amet aliquam commodo id sociosqu nostra nisi. Justo vulputate tristique nam varius; montes semper elementum. Convallis venenatis a ligula mauris risus."
            ]
        , HH.p_
            [ HH.text "Habitant rutrum nisl justo mollis aptent eu phasellus cubilia. Magnis ante platea sagittis, faucibus lectus laoreet. Massa metus quis efficitur; ex magna non justo. Scelerisque mollis aliquam convallis torquent in urna justo sagittis hac. Nunc nibh ipsum ipsum pulvinar varius dui dui habitasse. Cubilia non tempus pulvinar volutpat mauris nisl torquent. Suscipit pharetra est ac consequat; vestibulum ultrices malesuada. Varius ad integer cras mus nibh mus nunc mi hendrerit. Laoreet cras efficitur, est rutrum purus cursus taciti feugiat. Suscipit a eu praesent finibus massa vehicula vivamus."
            ]
        ]
    ]
