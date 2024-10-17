module Main where

import Prelude

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
  HA.runHalogenAff do
     body <- HA.awaitBody
     runUI
      component unit body


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
    HH.h1_
      [ HH.text "Hello World!"
      ]
