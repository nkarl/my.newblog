module Main where

import Prelude

import Capability.TransformArticles as TransArc
import Component.Router as Router
import Data.Maybe (Maybe(..))
import Data.Route (routeCodec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.Hash (matchesWith)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    hIO <- runUI Router.component unit body
    let testMdContent = "# Heading 1\n## Heading 2\nHello, world!"

    content <- TransArc.convertMarkdown testMdContent
    log $ show content

    void $ liftEffect $ do
      let
        route = parse routeCodec
        navigateToPath old new = when (old /= Just new)
          $ launchAff_
          $ void
          $ hIO.query
          $ H.mkTell
          $ Router.Navigate new
      matchesWith
        route
        navigateToPath
