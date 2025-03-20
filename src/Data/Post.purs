module Data.Post where

import Prelude
import Data.Maybe (Maybe)

type Post =
  { id :: String
  , content :: String
  , title :: String
  , description :: String
  , pubDate :: Maybe String
  , _type :: String
  , createdAt :: Number
  }
