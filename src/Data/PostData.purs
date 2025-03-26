module Data.PostData where

import Prelude

import Data.Argonaut.Decode (class DecodeJson, decodeJson, (.:), (.:?))
import Data.Maybe (Maybe, fromMaybe)

newtype PostData = PostData
  { content :: String
  , createdAt :: Number
  , description :: String
  , id :: String
  , pubDate :: Maybe String
  , title :: String
  , type :: Maybe String
  }

derive instance eqPost :: Eq PostData

-- | provides a implementation for the type class `DecodeJson` for the type `PostData`
-- | 
-- | `.:`  is first order transformation.
-- | `.:?` is monadic transformation for non-deterministic data encoding.
instance decodeJsonPost :: DecodeJson PostData where
  decodeJson json = do
    obj         <- decodeJson json
    id          <- obj .:  "id"
    content     <- obj .:  "content"
    title       <- obj .:  "title"
    description <- obj .:? "description" -- possibly empty
    pubDate     <- obj .:? "pubDate"     -- possibly empty
    type_       <- obj .:? "type"        -- possibly empty, possibly not needed
    createdAt   <- obj .:  "createdAt"
    pure
      $ PostData
          { id
          , content
          , title
          , description: fromMaybe "" description
          , pubDate
          , type: type_
          , createdAt
          }
