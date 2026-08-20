module Data.Route where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex', root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Home
  | Posts
  | Post String
  | Resume
  | Contact
  | Design

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route

routeCodec :: RouteDuplex' Route
routeCodec = root $ sum
  { "Home": noArgs
  , "Posts": "posts" / noArgs
  , "Post": "posts" / segment
  , "Resume": "resume" / noArgs
  , "Contact": "contact" / noArgs
  , "Design": "design" / noArgs
  }
