module Main where

import Prelude

import Component.Router as Router
import Data.Maybe (Maybe(..))
import Data.Route (routeCodec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.Hash (matchesWith)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    halogenIO <- runUI Router.component unit body

    void $ liftEffect $ (parse routeCodec) `matchesWith` \old new ->
      when (old /= Just new) $ launchAff_ do
        void $ halogenIO.query $ H.mkTell $ Router.Navigate new
