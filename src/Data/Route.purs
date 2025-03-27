module Data.Route where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Routing.Duplex (RouteDuplex', optional, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Home
  | Posts (Maybe String)
  -- | Post String
  | Resume
  | Contact

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route

routeCodec :: RouteDuplex' Route
routeCodec = root $ sum
  { "Home": noArgs
  , "Posts": "posts" / optional  segment 
  --, "Post": "posts" / segment
  , "Resume": "resume" / noArgs
  , "Contact": "contact" / noArgs
  }
