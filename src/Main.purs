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
    documentBody <- HA.awaitBody
    routerComponent <- runUI Router.component unit documentBody
    let
      route = parse routeCodec
      -- listen to any Router.Navigate query
      routeQuery = routerComponent.query <<< H.mkTell <<< Router.Navigate
      -- set the destination hash
      destination current next =
        when (current /= Just next)
          $ launchAff_
          $ void
          $ routeQuery next
    -- match route with destination
    void
      $ liftEffect
      $ route `matchesWith` destination
