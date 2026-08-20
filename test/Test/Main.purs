module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Either (Either(..))
import Data.Route (Route(..), routeCodec)
import Effect (Effect)
import Routing.Duplex (parse, print)
import Test.Assert (assert)

main :: Effect Unit
main = traverse_ roundTrips
  [ Home
  , Posts
  , Post "hello-purescript"
  , Resume
  , Contact
  , Design
  ]

roundTrips :: Route -> Effect Unit
roundTrips route =
  assert $ parse routeCodec (print routeCodec route) == Right route
